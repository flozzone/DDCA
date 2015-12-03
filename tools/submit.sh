#!/bin/bash

THIS=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

source $THIS/settings.sh
source $THIS/utils.sh

#
# Submits current source code to the tilab testing system
#
user=$1
group=$2
level=$3

remote_dir=$remote_root/$group/$level/src
tarball=current_repo.tar.gz
tmp_dir=`mktemp -d`

if [ -z `echo $level | egrep "^level[0123]$"` ]; then
  echo >&2 "Unknown level $level"
  usage
  exit 1
fi

#if ! do_ssh $user "ls &>/dev/null"; then
#  echo >&2 -e "User $user is not authorized.\n"
#  echo >&2 -e "Add your public key to the users authorized_keys file:\n"
#  echo >&2 -e "\t'ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$tilab_host'\n"
#  echo >&2 -e "or if not available:\n"
#  echo >&2 -e "\t'cat ~/.ssh/id_rsa.pub| ssh $user@$tilab_host \"cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\"'\n"
#  echo >&2 -e "If you don't have a public key, generate it \n\n\t'ssh-keygen -t rsa'."
#  exit 1
#fi

status=`git status --porcelain`
if [ -n "$status" ]; then
  echo >&2 "Working directory is not clean, uncommited files will not be submitted"

  read -p "Are you sure you want continue? [y|n]" -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$  ]]
  then
    # do dangerous stuff
    echo "Continue with dirty working directory."
  else
    echo >&2 "Aborting"
    return 1
  fi

fi

# create archive
echo "Creating archive of branch $_GIT_BRANCH at revision $_GIT_REV"
pushd $_GIT_WORK_TREE >/dev/null
git archive $_GIT_REV $_GIT_WORK_TREE/src | tar -x -C $tmp_dir
popd >/dev/null

pushd $tmp_dir/src >/dev/null


echo ""

#ret=`do_ssh $user "ls -A1 $remote_dir 2>/dev/null| wc -l"`
#if [ $ret -ne 0 ]; then
#  echo "Remote directory $remote_dir exists and is not empty."
#  echo "Remote dir will be synced to current repo contents, other files will be deleted"
#
#  read -p "Are you sure you want continue? [y|n]" -n 1 -r
#  echo    # (optional) move to a new line
#  if [[ $REPLY =~ ^[Yy]$  ]]
#  then
#    echo ""
#  else
#    echo "Aborting."
#    exit 0
#  fi
#
#fi

echo "Updating ..."
pushd $tmp_dir/src >/dev/null
echo "$_GIT_BRANCH $_GIT_REV" > version.txt
do_ssh $user "mkdir -p $remote_dir"

rsync -lvrgODzc --delete \
  --include "*.vhd" \
  --exclude "*" \
  . $user@$tilab_host:$remote_dir

do_ssh $user "chown -R :ddcagrp${group_nr} `dirname $remote_dir`"

popd >/dev/null

rm -rf $tmp_dir

echo -e "\nFiles successfully updated to $user@$tilab_host:$remote_dir"

echo ""
echo "Sending slack notification"
curl --data "$user has submitted $_GIT_BRANCH ($_GIT_REV) to $level." "https://${slack_host}/services/hooks/slackbot?token=${slack_token}&channel=%23${slack_channel}"

popd >/dev/null
