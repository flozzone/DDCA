#!/bin/bash

#
# checks all the project file inside the modelsim project if they are relative
# and otherwise corrects them
#

source settings.sh
source utils.sh

project_file=$_GIT_WORK_TREE/$modelsim_project_file

this=`pwd`
project_files=`sed -ne "s/^Project_File_[[:digit:]]*[[:space:]]=[[:space:]]\(.*\)$/\1/p" $project_file`

#
# http://stackoverflow.com/questions/2564634/convert-absolute-path-into-relative-path-given-a-current-directory-using-bash
#
abs_to_rel() {
  # both $1 and $2 are absolute paths beginning with /
  # returns relative path to $2/$target from $1/$source
  source=$1
  target=$2

  common_part=$source # for now
  result="" # for now

  while [[ "${target#$common_part}" == "${target}" ]]; do
      # no match, means that candidate common part is not correct
      # go up one level (reduce common part)
      common_part="$(dirname $common_part)"
      # and record that we went back, with correct / handling
      if [[ -z $result ]]; then
          result=".."
      else
          result="../$result"
      fi
  done

  if [[ $common_part == "/" ]]; then
      # special case for root (no common path)
      result="$result/"
  fi

  # since we now have identified the common part,
  # compute the non-common part
  forward_part="${target#$common_part}"

  # and now stick all parts together
  if [[ -n $result ]] && [[ -n $forward_part ]]; then
      result="$result$forward_part"
  elif [[ -n $forward_part ]]; then
      # extra slash removal
      result="${forward_part:1}"
  fi

  echo $result
}

has_abs=0
for file in $project_files; do
  if [ "${file:0:1}" = "/" ]; then
    has_abs=1
    echo >&2 "$project_file contains an absolute path to file $file."
    rel=`abs_to_rel $this $file`
    echo >&2 "Correcting it to $rel"
    sed -i "s|$file|$rel|g" $project_file
  fi
done

if [ -n $GIT_DIR ]; then
  if [ $has_abs -eq 1 ]; then
    echo >&2 -e "\n\nYour modelsim project file contains absolute paths."
    echo >&2 -e "They have been replaced by relative paths now, but you"
    echo >&2 -e "need to amend and stage the changes in order to continue"
    exit 1
  fi
fi
