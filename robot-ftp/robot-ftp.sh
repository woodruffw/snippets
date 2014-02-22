#!/usr/bin/env bash

#  robot-ftp.sh
#  Crawls through a list of IPs, FTPing into each and dropping a message file.
#  The message file's location is given to be the last directory in the first directory up from the root.
#  ----
#  IMPORTANT: Does not report errors, even when they occur.
#  Experimental success rate: 45% of servers receive message.
#  ----
#  Author: William Woodruff
#  Licensed under the MIT License: http://opensource.org/licenses/MIT

function usage()
{
	echo "Usage: $0 <IP file> <message file>"
}

[[ ! -e $1 || ! -e $2 ]] && usage ; exit 1

FTPFILE=$1
MSGFILE=$2
NEXTDIR=

cat $FTPFILE | while read IP
do
ftp -n $IP <<EOFTP > /dev/null
	user anonymous "fake@fake.com"
	ls . ls.txt
	bye
EOFTP

NEXTDIR=$(awk '{print $9}' ls.txt) 2> /dev/null
rm ls.txt 2> /dev/null

ftp -n $IP <<EOFTP > /dev/null
	user anonymous "fake@fake.com"
	cd "$NEXTDIR"
	ls . ls.txt
	bye
EOFTP

NEXTDIR="$NEXTDIR/$(tail -1 ls.txt | awk '{print $9}')" 2> /dev/null
rm ls.txt 2> /dev/null

ftp -n $IP <<EOFTP > /dev/null
	user anonymous "fake@fake.com"
	cd "$NEXTDIR"
	put $MSGFILE
	bye
EOFTP
done

exit 0
