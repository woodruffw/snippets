#!/usr/bin/env perl

#	aba-rtn.pl
#	Author: William Woodruff
#	------------------------
#	An ABA Routing Transit Number (RTN) check digit validator.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my $number = shift;

if (!$number || $number !~ /^\d{9}$/) {
	print "Usage: $0 <rtn>\n";
	exit;
}

my @digits = split('', $number);
my $result = ((3 * ($digits[0] + $digits[3] + $digits[6]))
			+ (7 * ($digits[1] + $digits[4] + $digits[7]))
			+ ($digits[2] + $digits[5])) % 10;

if ($result == $digits[$#digits]) {
	print "$number is a valid ABA RTN!\n";
}
else {
	print "$number is NOT a valid ABA RTN.\n";
}
