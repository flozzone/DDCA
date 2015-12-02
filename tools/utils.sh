#!/bin/bash

#
# source this file in order to use its functions
#

export _GIT_WORK_TREE=`git rev-parse --show-toplevel`
export _GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
export _GIT_REV=`git rev-parse HEAD`

check() {
  var=$1
  if [ -z $var ]; then
    usage
    exit 1
  fi
}
export -f check

do_ssh() {
  user=$1
  cmd=$2

  # uncomment for debugging
  #echo >&2 "ssh: $cmd"

  ssh -oBatchMode=yes -l $user $tilab_host "$cmd"
  ret=$?
  return $ret
}
export -f do_ssh
