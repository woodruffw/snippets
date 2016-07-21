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
	# ew
	gawk -F"\x00" '{
		for (i = 1; i <= NF; i++) {
			print $i
		}
	}' "/proc/${1}/environ" | grep WINDOWID | gawk -F= '{
		print $2
	}'
}

installed gawk || fatal "Missing dependency: gawk (GNU awk)."
[[ -n "${1}" ]] && [[ -d "/proc/${1}" ]] || usage

pid2xid "${1}"
