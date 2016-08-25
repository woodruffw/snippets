#!/usr/bin/env bash

#	watch-thunderbird.sh
#   Author: William Woodruff
#   ------------------------
#	Watch a Thunderbird profile for new emails, running a command whenever
#	a new one appears.
#	Problems:
#	- Interprets a write to each account's INBOX file as a new email. This
#		is almost certainly incorrect.
#	- Only works if the user only has one profile. I couldn't be bothered to
#		do this the "correct" way (with an INI parser and profile checking).
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) <cmd>\n"
	exit 1
}

function installed() {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function fatal() {
	>&2 printf "Fatal: ${*}\n"
	exit 1
}

[[ -n "${1}" ]] || usage
installed inotifywait || fatal "Missing dependency: inotifywait"
[[ "${BASH_VERSINFO[0]}" -ge 4 ]] || fatal "GNU bash 4.0 or later is required"

shopt -s globstar

profiles=(~/.thunderbird/*.default)

if [[ "${#profiles[@]}" -gt 1 ]]; then
	fatal "More than one profile found. This program can't handle that."
fi

watches=(${profiles[0]}/ImapMail/**/INBOX)

inotifywait -qm -e modify --format '%e' ${watches[@]} | while read event ; do
	eval "${1}" &
done
