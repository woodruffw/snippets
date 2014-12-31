#!/usr/bin/env bash

# cskel.sh: generate a C skeleton file and print its name
# usage: {vim,emacs,nano,ed} `cskel filename`
# ----
# Author: William Woodruff
# Licensed under the MIT License: http://opensource.org/licenses/MIT

if [[ -n "$1" ]]; then
	file="$1.c"
else
	file="cskel${RANDOM}.c"
fi

cat <<EOSKEL > "$file"

/* cskel $file */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

int main(int argc, char **argv)
{

}

EOSKEL

echo $file
