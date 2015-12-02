#!/bin/sh

#
# Installs the pre-commit hook as a client hook
# this needs to be done once per clone
#

_GIT_WORK_TREE=`git rev-parse --show-toplevel`
_GIT_DIR=`git rev-parse --git-dir`

hook_src="../../tools/git-pre-commit-hook"
hook_tgt="$_GIT_DIR/hooks/pre-commit"

echo "Installing git-pre-commit-hook to $hook_tgt" 
ln -sf $hook_src $hook_tgt
