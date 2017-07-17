#!/usr/bin/env bash

#	imgs2pdf.sh
#	Author: William Woodruff
#	------------------------
#	Converts a directory of images to a single PDF document.
#	Uses `convert` (ImageMagick).
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

function usage() {
	printf "Usage: %s <directory> <output.pdf>\n" $(basename "${0}")
	exit 1
}

function check_deps() {
	local deps=(convert)

	for dep in "${deps[@]}"; do
		if [[ ! $(which ${dep} 2>/dev/null) ]]; then
			printf "Fatal: Missing dependency: \'%s\'.\n" "${dep}"
			exit 1
		fi
	done
}

[[ ! -d "${1}" || -z "${2}" ]] && usage

check_deps

directory="${1}"
output="${2}"
img_glob="*.{gif,jpg,jpeg,png,tif,tiff}"

if [[ "${output}" != *.pdf ]]; then
	output="${output}.pdf"
fi

convert "${directory}/${img_glob}" "${directory}/${output}"
