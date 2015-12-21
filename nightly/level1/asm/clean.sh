#!/bin/bash

#
# Removes comment lines and empty lines and all lines until _start:
#
# useful to jump to the line matching the test number
#

tmp=$(mktemp)

sed -e 's/#.*$//' -e '/^[[:blank:]]*$/d' -e '0,/^_start:$/d' $1 | sed -n '/.end _start/q;p' | sed 's/^[[:blank:]]*//g' > $tmp

cat -n $tmp | sed 's/^[[:blank:]]*\([[:digit:]]+\)[[:blank:]]*\(.*\)/\1\#\2/g' > $2
