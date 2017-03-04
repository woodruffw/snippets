#!/usr/bin/env bash

# normalize-gifs.rb
# Author: William Woodruff
# ------------------------
# Normalize the supplied GIFs to the resolution specified by DIMS.
# Requires gifsicle.
# ------------------------
# This code is licensed by William Woodruff under the MIT License.
# http://opensource.org/licenses/MIT

installed() {
  local cmd=$(command -v "${1}")

  [[ -n  "${cmd}" ]] && [[ -f "${cmd}" ]]
  return ${?}
}

installed gifsicle || { echo "I need gifsicle to normalize GIFs."; exit 1; }

DIMS=${DIMS:-300x300}

mkdir -p "${DIMS}"

for gif in "${@}"; do
  printf "Normalizing ${gif}...\n"
  gifsicle -w --colors 256 --resize "${DIMS}" "${gif}" > "${DIMS}/$(basename ${gif})"
done
