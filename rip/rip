#!/usr/bin/env bash

#	rip.sh
#   Author: William Woodruff
#   ------------------------
#	Quick rip an audio CD into a specified format using abcde.
#	Requires abcde for ripping, flac/lame for encoding.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

function installed() {
	cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function fatal {
	>&2 echo "Fatal: ${*}"
	exit 2
}

[[ -n "${1}" ]] || fatal "Usage: $(basename "${0}") <format>"
installed abcde || fatal "Missing abcde for ripping."
installed glyrc || fatal "Missing glyrc for album art."

format=$(echo "${1}" | tr "[:upper:]" "[:lower:]")

case "${format}" in
	"mp3" ) installed lame || fatal "Missing lame for MP3 encoding." ;;
	"flac" ) installed flac || fatal "Missing flac for FLAC encoding." ;;
	* ) fatal "Unsupported format: ${format}. Maybe use abcde directly?"
esac

abcde -Vx -G -a "cddb,read,encode,tag,move,playlist,clean" -o "${format}"
