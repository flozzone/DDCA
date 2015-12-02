#!/bin/bash

source tools/settings.sh
source tools/utils.sh

usage() {
cat << EOF
USAGE:
  $0 COMMAND

COMMANDS::
  install
    Installs a git pre-commit hook that checks for relative file references
    in modelsims project file.

  cleanup
    Runs cleanup scripts.

  submit level0|level1|level2|level3 TILAB_USER
    Submits the current branch to the given level with the given TILAB_USER
    account. Your public key must be inside your remote authorized_keys file.

    Only files matching src/*vhd will be submitted.

    An additional version.txt file will be placed on the remote directory to
    keep track of the current version.

  help
    This help text
EOF
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

    exec ./tools/submit.sh $user $group $level
  ;;
  install)
    exec ./tools/install.sh
  ;;
  cleanup)
    exec ./tools/check_modelsim_project.sh
  ;;
  help)
    usage
    exit 0
  ;;
  *)
    usage
    exit 1
  ;;
esac
