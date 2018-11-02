#!/usr/bin/env bash

# ffcat: Concatenate a bunch of movies/media into a single file

set -eo pipefail

function help {
    echo "Usage: ffcat <output> <input [input ...]>"
    exit
}

function installed {
    cmd=$(command -v "${1}")

    [[ -n "${cmd}" ]] && [[ -f "${cmd}" ]]
    return ${?}
}

function cleanup {
    rm "${inputs_file}" 2>/dev/null
}

trap cleanup EXIT

inputs_file=$(mktemp -u ffcat_inputs_XXXXX.txt)

[[ "${#}" -ge 2 ]] || help

output="${1}" && shift

[[ ! -f "${output}" ]] || help

for input in "${@}"; do
    [[ -f "${input}" ]] || help
    echo "file '${input}'" >> "${inputs_file}"
done

installed ffmpeg || { >&2 echo "Missing ffmpeg."; exit 1; }

# you'd better hope your stream supports the `copy' encoder
ffmpeg -f concat -safe 0 -i "${inputs_file}" -c copy "${output}"
