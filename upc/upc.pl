#!/usr/bin/env perl

#	upc.pl
#	Author: William Woodruff
#	------------------------
#	A Universal Product Code (UPC) check digit validator.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my $number = shift;

if (!$number || $number !~ /^\d+$/) {
	print "Usage: $0 <upc>\n";
	exit;
}

my @nums = split('', $number);
my ($odds, $evens, $result) = 0;

for (my $i = 0; $i < scalar @nums - 1; $i++) {
	# confused? UPC starts counting from 1, so odd indices are even digits.
	if ($i % 2) {
		$evens += $nums[$i];
	}
	else {
		$odds += ($nums[$i] * 3);
	}
}

$result = (10 - (($odds + $evens) % 10));
$result = $result == 10 ? 0 : $result;

if ($result == $nums[$#nums]) {
	print "$number is a valid UPC!\n";
}
else {
	print "$number is NOT a valid UPC.\n";
}
