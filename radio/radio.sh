#!/usr/bin/env bash

#   radio.sh
#   Author: William Woodruff
#   ------------------------
#   Stream various radio stations defined in ~/.radiorc.
#   Requires mpv and GNU bash 4.0.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

player="mpv"
playeropts="--force-window=no"
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

[[ -f ~/.radiorc ]] || error "Missing ~/.radiorc"
[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && error "GNU bash 4.0 or later is required"
installed "${player}" || error "Missing dependency: '${player}'"

declare -A stations
source ~/.radiorc

[[ -z "${stations}" ]] || error "Missing radio stations in ~/.radiorc"

if [[ "${cmd}" = "usage" ]]; then
	usage
elif [[ "${cmd}" = "list" ]]; then
	list_stations
else
	station="${stations["${cmd}"]}"

	if [[ -z "${station}" ]]; then
		printf "No such station: '${cmd}'.\n"
		list_stations
		exit 1
	else
		eval "${player} ${playeropts} ${station}"
	fi
fi
