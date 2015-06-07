#!/usr/bin/env bash

#	sscc.sh
#	"Cascade" through common screenshot programs in an attempt to take
#	fullscreen and selection pictures.
#	Author: William Woodruff
# 	------------------------
# 	This code is licensed by William Woodruff under the MIT License.
# 	http://opensource.org/licenses/MIT

function usage() {
	echo "Usage: $(basename ${0}) <-s> <file>"
	exit 1
}

file="${1}"

while getopts "s:" opt; do
	case "${opt}" in
		s)	selection=1
			file="${2}"
			;;
		*)	usage
			;;
	esac
done

if [[ $(which gnome-screenshot 2>/dev/null) ]]; then
	if [[ "${selection}" -eq 1 ]]; then
		cmd="gnome-screenshot -a --file=${file}"
	else
		cmd="gnome-screenshot --file=${file}"
	fi
elif [[ $(which scrot 2>/dev/null) ]]; then
	if [[ "${selection}" -eq 1 ]]; then
		cmd="scrot -s ${file}"
	else
		cmd="scrot ${file}"
	fi
else
	>&2 echo "Nothing to take a screenshot with."
	exit 2
fi

eval "${cmd}"
echo "${file}"
