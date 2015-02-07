#!/usr/bin/awk -f

# linecheck.awk: report lines exceeding 80 characters in files
# usage: linecheck.awk file1 file2 ...
# ----
# Author: William Woodruff
# Licensed under the MIT License: http://opensource.org/licenses/MIT

BEGIN {
	max = 80
}

{
	if (length($0) > max)
	{
		printf "%s:%d exceeds %d characters.\n", FILENAME, FNR, max
	}
}

END {
	exit 0
}
