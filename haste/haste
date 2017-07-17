#!/usr/bin/env bash

# haste.sh - post files to hastebin and print a link. requires curl.
# usage: haste.sh <file> or pipe into haste
# ----
# Author: William Woodruff
# Licensed under the MIT License: http://opensource.org/licenses/MIT

if [[ -z "${1}" || "${1}" = "-" ]]; then
	data=$(cat)
elif [[ -f "${1}" ]]; then
	data=$(cat ${1})
else
	echo "Usage: $0 <file>"
	exit 1
fi

response=$(curl -X POST -s -d "${data}" http://hastebin.com/documents)
echo "${response}" | awk -F '"' '{print "http://hastebin.com/"$4}'
