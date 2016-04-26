#!/usr/bin/env bash

#   radio.sh
#   Author: William Woodruff
#   ------------------------
#   Stream various radio stations.
#   Requires mpv and GNU bash 4.0.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

player="mpv"
cmd="${1:-usage}"

function error() {
	>&2 printf "Fatal: ${@}. Exiting.\n"
	exit 2
}

function installed() {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function usage() {
	printf "Usage: $(basename ${0}) <station|list>\n"
	list_stations
	exit
}

function list_stations() {
	printf "Available stations:\n"
	for station in "${!stations[@]}"; do
		printf "\t${station}\n"
	done
}

[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && error "GNU bash 4.0 or later is required"
installed "${player}" || error "Missing dependency: '${player}'"

declare -A stations
stations=( ["wmuc"]="http://wmuc.umd.edu/wmuc-high.m3u"
		["wsum"]="http://stream.studio.wsum.wisc.edu/wsum128"
		["wknc"]="http://wknc.sma.ncsu.edu:8000/wknchq.ogg.m3u"
		["npr"]="http://npr.org/streams/mp3/nprlive24.m3u"
	)

if [[ "${cmd}" = "usage" ]]; then
	usage
else
	station="${stations["${cmd}"]}"

	if [[ -z "${station}" ]]; then
		printf "No such station: '${cmd}'.\n"
		list_stations
		exit 1
	else
		eval "${player} ${station}"
	fi
fi
