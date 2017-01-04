#!/usr/bin/env bash

#	poomf.sh
#	Author: Joe Schillinger, William Woodruff
#	------------------------
#	Upload to sr.ht and teknik.io.
#	Heavily modified from Joe Schillinger's poomf.sh (now uguu.sh).
#	------------------------
#	This code is licensed by Joe Schillinger under the MIT License.
#	http://opensource.org/licenses/MIT

function usage() {
	printf "%s <option>\n" $(basename ${0})
	printf "%s\n" "Options:"
	printf "%s\t\t\t%s\n" "-i" "interactive (zenity)"
	printf "%s\t\t\t%s\n" "-f" "fullscreen screenshot"
	printf "%s\t\t\t%s\n" "-h" "show this message"
	printf "%s\t\t\t%s\n" "-s" "selection screenshot"
	printf "%s\t\t%s\n" "-u <file>" "file upload"
	exit
}

function info() {
	notify-send ${@}
}

function installed() {
	local cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

function check_dependencies() {
	local deps=(notify-send zenity xclip curl jq exiftool)

	for dep in "${deps[@]}"; do
		if ! installed "${dep}" ; then
			printf "Missing dependency '${dep}', please install it.\n"
			exit 1
		fi
	done
}

function fullscreen_screenshot()
{
	local cmd=

	if installed maim ; then
		cmd="maim ${1}"
	elif installed gnome-screenshot ; then
		cmd="gnome-screenshot -f ${1}"
	elif installed scrot ; then
		cmd="scrot ${1}"
	else
		info "Nothing to take a screenshot with."
		exit 255
	fi

	eval "${cmd}"
}

function selection_screenshot()
{
	local cmd=

	if installed maim ; then
		cmd="maim -s ${1}"
	elif installed gnome-screenshot ; then
		cmd="gnome-screenshot -a -f ${1}"
	elif installed scrot ; then
		cmd="scrot -s ${1}"
	else
		info "Nothing to take a screenshot with."
		exit 255
	fi

	eval "${cmd}"
}

[[ -f ~/.api-keys/srht-api ]] && source ~/.api-keys/srht-api

check_dependencies

# get options
while getopts ifhsu: option; do
	case "${option}" in
		i)	interactive=1 ;;
		f)	fullscreen=1 ;;
		h)	usage ;;
		s)	selection=1 ;;
		u)	upload=1
			file="${OPTARG}" ;;
		*)	exit ;;
	esac
done

if [[ "${interactive}" ]]; then
	file=$(zenity --file-selection)
fi

# take fullscreen picture
if [[ "${fullscreen}" ]]; then
	file=$(filename=~/Dropbox/screenshots/$(date +%s).png ; fullscreen_screenshot "${filename}" ; printf "${filename}")
fi

# take selection picture
if [[ "${selection}" ]]; then
	file=$(filename=~/Dropbox/screenshots/$(date +%s).png ; selection_screenshot "${filename}" ; printf "${filename}")
fi

if [[ -n "${file}" ]]; then
	exiftool -overwrite_original -all= "${file}" > /dev/null

	if [[ -n "${SRHT_API_KEY}" ]]; then
		output=$(curl -sf -F key="${SRHT_API_KEY}" -F file="@${file}" "https://sr.ht/api/upload")

		if [[ -n "${output}" ]]; then
			url=$(echo "${output}" | jq -M -r ".url")
			success=1
		fi
	else
		output=$(curl -sf -F file="@${file}" "https://api.teknik.io/upload/post")

		if [[ -n ${output} ]]; then
			url=$(echo "${output}" | jq -M -r ".[0].results.file.url")
			success=1
		fi
	fi
fi

if [[ ${success} ]]; then
	# copy link to clipboard
	printf "${url}" | xclip -selection primary
	printf "${url}" | xclip -selection clipboard
	# notify user of completion
	info "pomf!" "${url}"
else
	info "%s\n" "file was not uploaded, did you specify a valid filename?"
fi
