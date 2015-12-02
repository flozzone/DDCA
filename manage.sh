#!/bin/bash

group_nr="7"
tilab_host="ssh.tilab.tuwien.ac.at"
remote_root="/ddcanightly"

_GIT_WORK_TREE=`git rev-parse --show-toplevel`

usage() {
cat << EOF
USAGE:
  $0 COMMAND

COMMANDS::
  submit level0|level1|level2|level3 TILAB_USER
    Submits the current git revision to the given level with the given TILAB_USER
    account. Your public key must be inside your remote authorized_keys file.

    Only files matching src/*vhd will be submitted.

    An additional version.txt file will be placed on the remote directory to
    keep track of the current version.

  cleanup
    Runs cleanup scripts.
EOF
}

check() {
  var=$1
  if [ -z $var ]; then
    usage
    exit 1
  fi
}

do_ssh() {
  user=$1
  cmd=$2

  echo >&2 "ssh: $cmd"

  ssh -oBatchMode=yes -l $user $tilab_host "$cmd"
  ret=$?
  return $ret
}


#
# Submits current source code to the tilab testing system
#
submit() {
  user=$1
  group=$2
  level=$3

  if [ -z `echo $level | egrep "^level[0123]$"` ]; then
    echo >&2 "Unknown level $level"
    usage
    exit 1
  fi

  if ! do_ssh $user "ls &>/dev/null"; then
    echo >&2 -e "User $user is not authorized.\n"
    echo >&2 -e "Add your public key to the users authorized_keys file:\n"
    echo >&2 -e "\t'ssh-copy-id -i ~/.ssh/id_rsa.pub $user@$tilab_host'\n"
    echo >&2 -e "or if not available:\n"
    echo >&2 -e "\t'cat ~/.ssh/id_rsa.pub| ssh $user@$tilab_host \"cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\"'\n"
    echo >&2 -e "If you don't have a public key, generate it \n\n\t'ssh-keygen -t rsa'."
    exit 1
  fi

  tarball=current_repo.tar.gz

  tmp_dir=`mktemp -d`
  branch=`git rev-parse --abbrev-ref HEAD`
  rev=`git rev-parse HEAD`


  ret=`git status --porcelain`
  if [ -n "$ret" ]; then
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

  echo "Creating archive of branch $branch at revision $rev"
  git archive --output=$tmp_dir/$tarball $rev $_GIT_WORK_TREE
  pushd $tmp_dir >/dev/null
  tar -xf $tarball

  remote_dir=$remote_root/$group/$level/src

  echo ""

  ret=`do_ssh $user "ls -A1 $remote_dir 2>/dev/null| wc -l"`
  if [ $ret -ne 0 ]; then
    echo "Remote directory $remote_dir exists and is not empty."
    echo "Remote dir will be synced to current repo contents, other files will be deleted"

    read -p "Are you sure you want continue? [y|n]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$  ]]
    then
      echo ""
    else
      echo "Aborting."
      exit 0
    fi

  fi

  echo "Submitting."
  pushd $tmp_dir/src >/dev/null
  echo "$branch $rev" > version.txt
  do_ssh $user "mkdir -p $remote_dir"
  rsync -avzc --delete *.vhd version.txt $user@$tilab_host:$remote_dir
  popd >/dev/null

  rm -rf $tmp_dir

  echo -e "\nFiles successfully uploaded to $user@$tilab_host:$remote_dir"

  popd
}

command=$1
check $command

case $command in
  submit)
    level=$2
    check $level
    user=$3
    check $user
    group=ddcagrp${group_nr}
    submit $user $group $level
  ;;
  cleanup)
    pushd $_GIT_WORK_TREE/sim >/dev/null
    ./check_modelsim_project.sh
    popd >/dev/null
  ;;
  *)
    usage
    exit 1
  ;;
esac
