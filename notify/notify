#!/usr/bin/env bash

#   notify.sh
#   Author: William Woodruff
#   ------------------------
#   Notify the user with a message in X.
#   Cascades through preferable notification programs.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) <message>\n"
	exit 1
}

function installed() {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function notify() {
	local notify_cmd="xmessage -center -timeout 3 '${@}'"

	if installed zenity; then
		notify_cmd="zenity --info --timeout=3 --text='${@}'"
	fi

	if installed notify-send; then
		notify_cmd="notify-send --expire-time=3000 info '${@}'"
	fi

	eval "${notify_cmd}" &
}

[[ -n "${@}" ]] || usage

notify "${@}"

# all notifiers return different things, so just return 0 for uniformity
exit
