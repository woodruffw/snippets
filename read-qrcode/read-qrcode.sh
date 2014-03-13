#!/usr/bin/env bash

#  read-qrcode.sh
#  reads the QR code image provided by the user, outputting its contents
#  Depends on ZBar (specifically zbarimg).
#  Author: William Woodruff
#  Licensed under the MIT License: http://opensource.org/licenses/MIT

function usage()
{
	printf "Usage: $0 <image>\n"
}

[[ ! -e $1 ]] && usage && exit 1

QRFILE=$1
OUTPUT=`zbarimg $QRFILE --quiet | sed 's/^QR-Code://'`
echo $OUTPUT

exit 0
