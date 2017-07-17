#!/usr/bin/env perl

#  fetch-math-finals.pl
#  Author: William Woodruff
#  ------------------------
#  Fetches all finals in UMD's math testbank matching the given course.
#  Depends on WWW::Mechanize.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use WWW::Mechanize;

$| = 1;

my $course = shift or die "Usage: $0 <course code>\n";
my $url = "http://db.math.umd.edu/testbank/?courseNumber=$course&instructor=Any&year=Any&semester=Any&Search=Search";
my $mech = WWW::Mechanize->new(agent => 'fetch-math-finals/perl/iamarobot (github.com/woodruffw/snippets)');
my $count = 1;
my @final_links;
my $num_finals;

$mech->get($url);

@final_links = $mech->find_all_links(text_regex => qr/FINAL/);
$num_finals = scalar(@final_links);

if ($num_finals == 0) {
	print "No finals found. Exiting.\n"
}
else {
	print "Found ", $num_finals, " finals. Downloading:\n";
	mkdir 'finals';

	foreach (@final_links) {
		$mech->get($_);
		$mech->save_content('finals/' . $count . '.pdf');
		print 'Saved ', $count, ' of ', $num_finals, ".\n";
		$count++;
	}

	print "Done.\n"
}

exit 0;
