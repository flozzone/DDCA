#!/bin/bash

#
# Removes comment lines and empty lines and all lines until _start:
#
# useful to jump to the line matching the test number
#

sed -i -e 's/#.*$//' -e '/^[[:blank:]]*$/d' -e '0,/^_start:$/d' $1
