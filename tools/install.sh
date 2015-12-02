#!/bin/bash

#
# Installs the pre-commit hook as a client hook
# this needs to be done once per clone
#

THIS=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

source $THIS/settings.sh
source $THIS/utils.sh

hook_src="$_GIT_WORK_TREE/tools/git-pre-commit-hook"
hook_tgt="$_GIT_WORK_TREE/.git/hooks/pre-commit"

echo "Installing git-pre-commit-hook to $hook_tgt" 
ln -sf $hook_src $hook_tgt
