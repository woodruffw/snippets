#!/usr/bin/env bash

#	upload.sh
#	A generic file uploading script that attempts to push a file to a few
#	filesharing services in sequential order.
#	Author: William Woodruff
# 	------------------------
# 	This code is licensed by William Woodruff under the MIT License.
# 	http://opensource.org/licenses/MIT

function usage() {
	echo "Usage: $(basename ${0}) <file>"
	exit 1
}

function dependencies() {
	echo "I require the 'jq' utility to function."
	echo "Please install 'jq' with your package manager."
	exit 2
}

function info() {
	>&2 echo "${@}"
}

[[ -f "${1}" ]] || usage
[[ $(which jq 2>/dev/null) ]] || dependencies

file=${1}

info "Trying pomf.se first..."

output=$(curl --silent -sf -F files[]="@${file}" "http://pomf.se/upload.php")

if [[ -n "${output}" ]]; then
	info "Succeeded."
	slug=$(echo "${output}" | jq -M -r ".files[0].url")
	url="https://a.pomf.se/${slug}"
else
	info "Failed. Trying teknik.io..."
	output=$(curl --silent -sf -F file="@${file}" "https://api.teknik.io/upload/post")
	url=$(echo ${output} | jq -M -r ".[0].results.file.url")
fi

echo "${url}"
