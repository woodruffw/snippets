#!/usr/bin/env bash

# git-fetch-pr: fetch a pull request and check it out as a branch

usage() {
	echo "usage: git fetch-pr <pr #>"
	exit
}

[[ -z "${1}" ]] && usage

git fetch origin "pull/${1}/head:pr-${1}"
git checkout "pr-${1}"
