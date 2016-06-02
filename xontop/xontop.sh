#!/usr/bin/env bash

#	xontop.sh
#   Author: William Woodruff
#   ------------------------
#   Adds or removes the 'above' property from an X11 window.
#	Requires xwininfo, wmctrl, and an EWMH compatible window manager.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: $(basename ${0}) [-h|-b]\n"
	printf "\tWithout arguments, adds the 'above' property to a selected window.\n"
	printf "\t-b Remove the window's 'above' property instead of adding it.\n"
	printf "\t-h Show this message.\n"
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

installed xwininfo || { notify "$(basename ${0}) needs 'xwininfo'." ; exit 1 ; }
installed wmctrl || { notify "$(basename ${0}) needs 'wmctrl'." ; exit 1 ; }

act="add"

case "${1}" in
	"-b" ) act="remove" ;;
	"-h" ) usage ;;
esac

wid=$(xwininfo -int | grep 'Window id' | awk '{ print $4 }')
wmctrl -i -r "${wid}" -b "${act}",above
