#!/usr/bin/env perl

#	damm.pl
#	Author: William Woodruff
#	------------------------
#	A table implementation of the Damm check digit generation and validation
#	algorithms. The Damm algorithm is similar to the Verhoeff algorithm, but
#	detects all adjacent transposition errors instead of just most.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

my @table = (
	[0, 3, 1, 7, 5, 9, 8, 6, 4, 2],
	[7, 0, 9, 2, 1, 5, 4, 8, 6, 3],
	[4, 2, 0, 6, 8, 7, 1, 3, 5, 9],
	[1, 7, 5, 0, 9, 8, 3, 4, 2, 6],
	[6, 1, 2, 3, 0, 4, 5, 9, 7, 8],
	[3, 6, 7, 4, 2, 0, 9, 5, 8, 1],
	[5, 8, 6, 9, 7, 2, 0, 1, 3, 4],
	[8, 9, 4, 5, 3, 6, 2, 0, 1, 7],
	[9, 4, 3, 8, 6, 1, 7, 2, 0, 5],
	[2, 5, 8, 1, 4, 3, 6, 7, 9, 0]);

my ($command, $number) = @ARGV;

if (!$command || $command !~ /^(validate)|(generate)$/i
	|| !$number || $number !~ /^\d+$/) {
	usage();
}
else {
	damm(lc $command, $number);
}

sub usage {
	print "Usage: $0 <validate | generate> <number>\n";
	exit;
}

sub damm {
	my $cmd = shift;
	my @n = split('', shift);
	my $c = 0;

	foreach (@n) {
		$c = $table[$c][$_];
	}

	if ($cmd eq "validate" && $c == 0) {
		print @n, " is valid!\n";
	}
	elsif ($cmd eq "generate") {
		push @n, $c;
		print @n, " is your number with a Damm check digit.\n";
	}
	else {
		print @n, " is not valid!\n";
	}
}
