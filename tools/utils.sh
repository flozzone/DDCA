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

# check if stdout is a terminal...
if test -t 1; then

    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        export bold="$(tput bold)"
        export underline="$(tput smul)"
        export standout="$(tput smso)"
        export normal="$(tput sgr0)"
        export black="$(tput setaf 0)"
        export red="$(tput setaf 1)"
        export green="$(tput setaf 2)"
        export yellow="$(tput setaf 3)"
        export blue="$(tput setaf 4)"
        export magenta="$(tput setaf 5)"
        export cyan="$(tput setaf 6)"
        export white="$(tput setaf 7)"
    fi
fi
