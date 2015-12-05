#!/bin/bash

file=$1

if [ -z $file ]; then
  echo >&2 "Usage: $0 ASSEMBLY_FILE"
  exit 1
fi


sed -i "s|_start|main|g" $file
sed -i 's|^[[:blank:]]*.size main.*$|\t\tli $v0, 10\n\t\tsyscall|g' $file
