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
level_dir=$remote_root/$group/$level
tarball=current_repo.tar.gz
tmp_dir=`mktemp -d`

if [ -z `echo $level | egrep "^level[0123]$"` ]; then
  echo >&2 "Unknown level $level"
  usage
  exit 1
fi

status=`git status --porcelain`
if [ -n "$status" ]; then
  echo -e >&2 "${red}Working directory is not clean, uncommited files will not be submitted${normal}"
fi

# create archive
echo "Creating archive of branch $_GIT_BRANCH at revision $_GIT_REV"
pushd $_GIT_WORK_TREE >/dev/null
if ! git archive $_GIT_REV $_GIT_WORK_TREE/src | tar -x -C $tmp_dir; then
    echo >&2 "Could not create an archive of current branch."
    exit 1   
fi

# create version file
pushd $tmp_dir >/dev/null
echo "$_GIT_BRANCH $_GIT_REV" > version.txt

# create remote directory and set group
do_ssh $user "mkdir -p $remote_dir && chgrp ${group} $level_dir" &>/dev/null

# Note:
#  --groupmap "*:${group}" option is not supported by remote rsync
# because at the time of writing this, remote rsync version
# is 3.0.9 and --groupmap feature has been included starting
# with version 3.1.0
if ! rsync -vlrODzc --delete \
          --include "src/*.vhd" \
          --include "version.txt" \
          --exclude "src/*/" \
          --exclude ".gitignore" \
          . $user@$tilab_host:$level_dir ; then
    echo >&2 "Could not transmit all files successfully."
fi

if ! do_ssh $user "chgrp -R -f ddcagrp${group_nr} `dirname $remote_dir`" ; then
    echo >&2 "Could not change group of uploaded files."
fi

popd >/dev/null

rm -rf $tmp_dir

echo ""
echo -n "Sending slack notification ... "
echo $(curl --silent --data "$user has submitted $_GIT_BRANCH ($_GIT_REV) to $level." "https://${slack_host}/services/hooks/slackbot?token=${slack_token}&channel=%23${slack_channel}")

popd >/dev/null
