#!/bin/bash

uart_output=$1
last_result=$2
expect_file=$3

if [ -z "$uart_output" ]; then
  exit 1
fi
if [ -z "$last_result" ]; then
  exit 1
fi
if [ -z "$expect_file" ]; then
  exit 1
fi


echo "RUN TEST against $expect_file"

if ! sed 's/^$/\t/g' $uart_output | tr -d '\n' | sed 's/\t\t/\n/g' > $last_result ; then
  exit 1
fi

if [ ! -f $expect_file ]; then
  echo "No expect file found. So no test, instead just print program output:"
  cat $last_result
  exit 0
else
  diff $last_result $expect_file
  ret=$?
  if [ $ret != 0 ]; then
    echo "TEST FAILED"
    exit 2
  fi

  echo "TEST PASSED"

  exit 0
fi
