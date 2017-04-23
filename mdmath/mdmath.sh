#!/usr/bin/env bash

#	mdmath.sh
#	Author: William Woodruff
#	------------------------
#	A basic preprocessor for LaTeX math equations in Markdown.
#	Converts LaTeX math formatting inside @@...@@ into images.
#	Images are generated by latex.codecogs.com.
#	Requires: curl, sed, shasum.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

usage() {
	echo "Usage: shellcheck [-h] <file>"
	exit 1
}

error() {
	>&2 echo "Fatal: ${*}. Exiting."
	exit 2
}

installed() {
	cmd=$(command -v "${1}")

	[[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
	return ${?}
}

installed curl || error "curl is required"
installed sed || error "sed is required"
installed shasum || error "shasum is required"

[[ -z "${1}" ]] && usage
[[ -f "${1}" ]] || error "No such file: '${1}'"

# everything below this is ugly.

IFS=$'\n'
matches=($(sed -n 's,.*@@\(.*\)@@.*,\1,p' "${1}"))
unset IFS
slugs=( )

for i in "${!matches[@]}"; do
	sha=$(echo "${matches[i]}" | shasum)
	slugs[${i}]="${sha:0:6}"
	echo "???"
	curl -sG 'http://latex.codecogs.com/png.latex' --data-urlencode "${matches[i]}" > "${slugs[i]}.png"
	echo "???"

	matches[${i}]=$(printf '%s\n' "${matches[i]}" | sed -e 's/\\/\\\\/g' | sed -e 's/\^/\\\^/g')
	if [[ -z "${output}" ]]; then
		output=$(sed 's,@@'"${matches[i]}"'@@,![](./'"${slugs[i]}.png"'),' "${1}")
	else
		output=$(sed 's,@@'"${matches[i]}"'@@,![](./'"${slugs[i]}.png"'),' <<< "${output}")
	fi
done

echo "${output}"

