#!/usr/bin/env bash

#   tal.sh
#   Author: William Woodruff
#   ------------------------
#   Stream episodes of This American Life.
#   Requires mpv and GNU bash 4.0.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

player="mpv"
playeropts="--force-window=no --no-ytdl"
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
	printf "Usage: $(basename ${0}) <episode #>\n"
	exit
}

[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && error "GNU bash 4.0 or later is required"
installed "${player}" || error "Missing dependency: '${player}'"
[[ -n "${1}" ]] || usage

episode="http://stream.thisamericanlife.org/${1}/stream/${1}_64k.m3u8"

eval "${player} ${playeropts} ${episode}"
