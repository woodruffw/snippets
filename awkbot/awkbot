#!/usr/bin/gawk -f

# awkbot.awk - a proof of concept IRC bot written in (GNU) AWK.
# Usage: awkbot.awk <nick> <server> <chan1,chan2,...>
# ----
# Author: William Woodruff
# Licensed under the MIT License: http://opensource.org/licenses/MIT

BEGIN {
	if (ARGC < 4) {
		print "Usage: ./awkbot.awk <nick> <server> <chan1,chan2,...>"
		exit -1
	}
	else {
		nick = ARGV[1]
		server = ARGV[2]
		split(ARGV[3], channels, ",")
		ARGC = 0
	}

	socket = "/inet/tcp/0/" server "/6667"
	
	handshake()
	main_loop()
}

function handshake() {
	printf "NICK " nick "\r\n" |& socket
	printf "USER " nick " 0 * :" nick "\r\n" |& socket
	
	for (i in channels) {
		printf "JOIN :#" channels[i] "\r\n" |& socket
	}
}

function main_loop() {
	while (socket |& getline line) {
		print line
		split(line, array, " ")
		
		if (array[1] == "PING") {
			printf "PONG " array[2] "\r\n" |& socket
		}
		else {
			switch (array[2]) {
				case "PRIVMSG":
					handle_msg(array)
					break
				# add more IRC codes here...
			}
		}
	}
}

function handle_msg(array) {
	cmd = substr(array[4], 2)
	sub(/[\r\n]+/, "", cmd)
	switch (cmd) {
		case /^\.bots$/:
			privmsg(socket, array[3], "Reporting in! [AWK]")
			break
		# add more triggers here...
	}
}

function privmsg(socket, target, msg) {
	printf "PRIVMSG " target " :" msg "\r\n" |& socket
}

END {
	close(socket)
}
