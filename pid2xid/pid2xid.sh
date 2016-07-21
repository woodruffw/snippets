#!/usr/bin/env bash

#	pid2xid.sh
#	Author: William Woodruff
#	------------------------
#	Prints the X Window ID (xid) associated with a process ID.
#	Requires GNU awk.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) <pid>\n"
	exit 1
}

function fatal() {
	>&2 printf "Fatal: ${*}. Exiting.\n"
	exit 2
}

function installed() {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function pid2xid() {
	local xids=($(xwininfo -int -children -root | sed -e '1,6d' | awk '{ print $1 }'))
	for xid in "${xids[@]}"; do
		[[ "${xid}" != [0-9]* ]] && continue
		local pid=$(xprop -id "${xid}" _NET_WM_PID | awk '{ print $3 }')
		[[ "${pid}" != [0-9]* ]] && continue

		if [[ "${pid}" -eq "${1}" ]]; then
			printf "${xid}\n"
			break
		fi
	done
}

installed gawk || fatal "Missing dependency: gawk (GNU awk)."
[[ -n "${1}" ]] && [[ -d "/proc/${1}" ]] || usage

pid2xid "${1}"
