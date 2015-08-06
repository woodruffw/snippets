#!/usr/bin/env bash

#	flac2mp3.sh
#	Author: William Woodruff
#	------------------------
#	Converts flac files in the current directory into mp3s.
#	Requires ffmpeg or avconv.
#	------------------------
#	Author: William Woodruff
#	Licensed under the MIT License: http://opensource.org/licenses/MIT

shopt -s nullglob

function usage() {
	printf "Usage: $(basename ${0}) [-sdvh]\n"
	printf "\t-s - convert files sequentially, instead forking for each\n"
	printf "\t-d - delete flac files after conversion\n"
	printf "\t-v - be verbose\n"
	printf "\t-h - print this usage information\n"
	exit 1
}

function verbose() {
	if [[ "${verbose}" ]]; then
		printf "${@}"
	fi
}

function error() {
	>&2 printf "Fatal: ${@}"
	exit 2
}

function flac2mp3() {
	flac_file="${1}"
	mp3_file="${flac_file%.flac}.mp3"

	verbose "Beginning '${flac_file}' -> '${mp3_file}'.\n"
	"${conv}" -y -i "${flac_file}" -b:a 320k "${mp3_file}" &> /dev/null 
	verbose "Completed '${mp3_file}'.\n"
}

if which ffmpeg > /dev/null; then
	conv=ffmpeg
elif which avconv > /dev/null; then
	conv=avconv
else
	error "Could not find either ffmpeg or avconv to convert with.\n"
fi

while getopts ":sdv" opt; do
	case "${opt}" in
		s ) sequential=1 ;;
		d ) delete=1 ;;
		v ) verbose=1 ;;
		* )	usage ;;
	esac
done

flacs=(*.flac)

if [[ "${sequential}" ]]; then
	verbose "Converting sequentially.\n"

	for file in "${flacs[@]}"; do
		flac2mp3 "${file}"
	done
else
	verbose "Converting in parallel.\n"

	for file in "${flacs[@]}"; do
		flac2mp3 "${file}" &
	done

	wait
fi

if [[ "${delete}" ]]; then
	verbose "Deleting old FLACs..."
	rm -rf *.flac
	verbose "done.\n"
fi

verbose "All done. ${#flacs[@]} files converted.\n"
