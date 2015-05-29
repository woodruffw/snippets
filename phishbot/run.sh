#!/usr/bin/env bash
#  run.sh
#  Run phishbot.rb with a few common nick typos.

network="irc.rizon.net"
channel="#phishbot"
nicks=(NickSerc NickSerf MickServ KickServ) # limit it to 4 for now

for nick in "${nicks[@]}"; do
	ruby ./phishbot.rb "$network" "$nick" "$channel" 2>/dev/null &
	echo "Kill this pid to end ${nick} on ${network}: $!"
done
