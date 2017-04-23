#!/usr/bin/env bash

#	xontop.sh
#   Author: William Woodruff
#   ------------------------
#   Adds or removes the 'above' property from an X11 window.
#	Requires xwininfo, wmctrl, and an EWMH compatible window manager.
#   ------------------------
#   This code is licensed by William Woodruff under the MIT License.
#   http://opensource.org/licenses/MIT

usage() {
	cat <<-EOS
		Usage: xontop [-h|-b]

		Arguments:
		-b Remove the window's 'above' property instead of adding it.
		-h Show this message.
	EOS
	exit 1
}

installed() {
	cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}


notify() {
	local notify_cmd="xmessage -center -timeout 3 '${*}'"

	if installed zenity; then
		notify_cmd="zenity --info --timeout=3 --text='${*}'"
	fi

	if installed notify-send; then
		notify_cmd="notify-send --expire-time=3000 info '${*}'"
	fi

	eval "${notify_cmd}" &
}

installed xwininfo || { notify "xontop needs 'xwininfo'." ; exit 1 ; }
installed wmctrl || { notify "xontop needs 'wmctrl'." ; exit 1 ; }

act="add"

case "${1}" in
	"-b" ) act="remove" ;;
	"-h" ) usage ;;
esac

wid=$(xwininfo -int | grep 'Window id' | awk '{ print $4 }')
wmctrl -i -r "${wid}" -b "${act}",above
