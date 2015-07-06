#!/usr/bin/env perl

#	issn.pl
#	Author: William Woodruff
#	------------------------
#	An International Standard Serial Number (ISSN) check digit validator.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my @weights = (8, 7, 6, 5, 4, 3, 2); # these 'weights' are reversed indices

my $number = shift;

if (!$number || $number !~ /^\d{4}-\d{3}[\dxX]$/) {
	print "Usage: $0 <issn>\n";
	exit;
}

my @digits = split('', uc $number);
splice @digits, 4, 1;
my $result = 0;

for (my $i = 0; $i < scalar @digits - 1; $i++) {
	$result += ($digits[$i] * $weights[$i]);
}

$result = 11 - ($result % 11);
$result = $result == 10 ? 'X' : $result;

if ($result eq $digits[$#digits]) {
	print "$number is a valid ISSN!\n";
}
else {
	print "$number is NOT a valid ISSN.\n";
}
