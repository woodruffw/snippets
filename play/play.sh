#!/usr/bin/env bash

#	play.sh
#	Author: William Woodruff
#	------------------------
#	Plays a URL or file, leveraging youtube-dl and livestreamer if installed.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) <file or URL>\n"
	exit 1
}

function fatal {
	>&2 printf "Fatal: ${*}. Exiting.\n"
	exit 2
}

function warn {
	>&2 printf "Warning: ${*}.\n"
}

function info {
	printf "Info: ${*}.\n"
}

function installed {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function url {
	local regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	[[ "${1}" =~ ${regex} ]]
	return ${?}
}

[[ "${BASH_VERSINFO[0]}" -lt 4 ]] && fatal "GNU bash 4.0 or later is required"
[[ -n "${1}" ]] || usage

player="mpv"

installed "${player}" || fatal "Missing dependency: ${player}"

if installed "livestreamer" && livestreamer --can-handle-url "${1}" \
	&& ! [[ "${1}" =~ youtu ]]; then
	info "Attempting to play with livestreamer"
	livestreamer --player-no-close --player "${player}" "${1}" best
elif installed "youtube-dl" && url "${1}"; then
	info "Attempting to play with youtube-dl"

	if [[ "${player}" = "mpv" ]]; then
		mpv "${1}"
	else
		# hope your player supports streaming from stdin
		youtube-dl "${1}" -o - | "${player}" -
	fi
elif [[ -f "${1}" ]]; then
	info "Attempting to play from disk"

	"${player}" "${1}"
else
	fatal "${1} can't be handled."
fi
