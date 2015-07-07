#!/usr/bin/env perl

#	vin.pl
#	Author: William Woodruff
#	------------------------
#	A North American Vehical Identification Number (VIN) check digit validator.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my %trans_table = (
	A => 1,
	B => 2,
	C => 3,
	D => 4,
	E => 5,
	F => 6,
	G => 7,
	H => 8,
	J => 1,
	K => 2,
	L => 3,
	M => 4,
	N => 5,
	P => 7,
	R => 9,
	S => 2,
	T => 3,
	U => 4,
	V => 5,
	W => 6,
	X => 7,
	Y => 8,
	Z => 9);

my @weights = (8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2);

my $number = shift;

if (!$number || $number !~ /^[\dA-HJ-NPR-Z]{8}[\dX][\dA-HJ-NPR-Z]{2}\d{6}$/) {
	print "Usage: $0 <vin>\n";
	exit;
}

my @digits = split('', $number);
my $result = 0;

for (my $i = 0; $i < scalar @digits; $i++) {
	my $digit = $digits[$i];

	if (exists $trans_table{$digits[$i]}) {
		$digit = $trans_table{$digits[$i]};
	}

	$result += ($digit * $weights[$i]);
}

$result %= 11;
$result = $result == 10 ? 'X' : $result;

if ($result eq $digits[8]) {
	print "$number is a valid VIN!\n";
}
else {
	print "$number is NOT a valid VIN.\n";
}
