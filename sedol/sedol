#!/usr/bin/env perl

#	sedol.pl
#	Author: William Woodruff
#	------------------------
#	A Stock Exchange Daily Official List (SEDOL) ID check digit validator.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my @weights = (1, 3, 1, 7, 3, 9, 1);

my $number = shift;

if (!$number || $number !~ /^[\dB-Z]{7}$/) {
	print "Usage: $0 <sedol id>\n";
	exit;
}

my @digits = split('', $number);
my $result = 0;

for (my $i = 0; $i < scalar @digits - 1; $i++) {
	$result += ($digits[$i] * $weights[$i]);
}

$result = (10 - ($result % 10)) % 10;

if ($result == $digits[$#digits]) {
	print "$number is a valid SEDOL ID!\n";
}
else {
	print "$number is NOT a valid SEDOL ID.\n";
}
