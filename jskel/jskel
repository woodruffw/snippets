#!/usr/bin/env bash

# jskel: generate a Java skeleton file and print its name
# usage: {vim,emacs,nano,ed} `jskel newfile` 

if [[ -n "${1}" ]]; then
	file="${1}.java"
else
	echo "Usage: ${0} <filename>"
fi

cat <<EOSKEL > "${file}"

/* jskel ${file} */

import java.util.*;

public class ${1}
{
	public static void main(String[] args)
	{

	}
}

EOSKEL

echo "${file}"
