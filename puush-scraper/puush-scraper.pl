#!/usr/bin/env perl

#  puush-scraper.pl
#  Author: William Woodruff
#  ------------------------
#  Scrapes puu.sh, downloading n semirandom files via semirandom brute-guessing
#  Stores downloaded files in a timestamped directory
#  Depends upon WWW::Mechanize and HTTP::Response.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use WWW::Mechanize;
use HTTP::Response;

my @main_table = (0..9, 'a'..'z', 'A'..'Z');
my @prefix_table = (0, 4, 7, 8); # these seem to be the most common first digits on puu.sh URLs

my $num_files = shift || die "Usage: puush-scraper.pl <number of files>\n";
my $mech = WWW::Mechanize->new(agent => 'puush-scraper/perl/iamarobot', autocheck => 0);

mkdir "scrape";

my $file_count = 1;
while ($file_count <= $num_files)
{
	my $item = $prefix_table[int(rand(4))] . $main_table[int(rand(62))] . $main_table[int(rand(62))] . $main_table[int(rand(62))] . $main_table[int(rand(62))];
	my $url = "http://www.puu.sh/$item";
	my $response = $mech->get($url);

	if ($response->is_success)
	{
		print "FILE FOUND ($item): $file_count out of $num_files\n";
		my $content = $mech->ct();

		if ($content =~ /jpeg/)
		{
			$mech->save_content("scrape/$item.jpg", decoded_by_headers => 1);
		}
		elsif ($content =~ /png/)
		{
			$mech->save_content("scrape/$item.png", decoded_by_headers => 1);
		}
		elsif ($content =~ /gif/)
		{
			$mech->save_content("scrape/$item.gif", decoded_by_headers => 1);
		}
		elsif ($content =~ /text/)
		{
			$mech->save_content("scrape/$item.txt", decoded_by_headers => 1);
		}
		else
		{
			$mech->save_content("scrape/$item.other", decoded_by_headers => 1);
		}

		$file_count++;
	}
}