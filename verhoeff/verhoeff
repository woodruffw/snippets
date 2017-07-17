#!/usr/bin/env perl

#	verhoeff.pl
#	Author: William Woodruff
#	------------------------
#	A table implementation of the Verhoeff check digit generation and validation
#	algorithms. The Verhoeff algorithm is more complex than the Luhn validation
#	algorithm, but detects more adjacent two-digit transposition errors.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

use strict;
use warnings;

# Cayley table of dihedral group D_5
my @d = (
	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
	[1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
	[2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
	[3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
	[4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
	[5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
	[6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
	[7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
	[8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
	[9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);

# multiplicative inverses of each index
my @inv = (0, 4, 3, 2, 1, 5, 6, 7, 8, 9);

# permutations of (1 5 8 9 4 2 7 0)(3 6)
my @p = (
	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
	[1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
	[5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
	[8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
	[9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
	[4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
	[2, 7, 9, 3, 9, 0, 6, 4, 1, 5],
	[7, 0, 4, 6, 9, 1, 3, 2, 5, 8]);

my ($command, $number) = @ARGV;

if (!$command || $command !~ /^(validate)|(generate)$/i
	|| !$number || $number !~ /^\d+$/) {
	usage();
}
else {
	verhoeff(lc $command, $number);
}

sub usage {
	print "Usage: $0 <validate | generate> <number>\n";
	exit;
}

sub verhoeff {
	my $cmd = shift;
	my @n = split('', shift);
	my $c = 0;

	if ($cmd eq "generate") {
		push @n, 0;
	}

	@n = reverse @n;

	for (my $i = 0; $i < scalar @n; $i++) {
		$c = $d[$c][$p[$i % 8][$n[$i]]];
	}

	# unreverse for output
	@n = reverse @n;

	if ($cmd eq "validate" && $c == 0) {
		print @n, " is valid!\n";
	}
	elsif ($cmd eq "generate") {
		$n[$#n] = $inv[$c];
		print @n, " is your number with a Verhoeff check digit.\n";
	}
	else {
		print @n, " is not valid!\n";
	}
}
