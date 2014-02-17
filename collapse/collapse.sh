#!/usr/bin/env bash

#  collapse.sh
#  collapses the given directory into its parent directory
#  Author: William Woodruff
#  Licensed under the MIT License: http://opensource.org/licenses/MIT

function usage()
{
	printf "Usage: $0 [directory]\n"
}

if [ ! -d "$1" ] ; then
	printf "Error: no such directory\n"
	usage
else
	cp -r "$1/." "$1/../"
	rm -r "$1"
fi
