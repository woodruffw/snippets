#!/usr/bin/env perl

#  wtf-urban.pl
#  Author: William Woodruff
#  ------------------------
#  A spiritual descendant of NetBSD's 'wtf' acronym expander, wtf-urban grabs definitions
#  from urbandictionary.com's API.
#  By default, the first definition is grabbed. However, the -l <number> flag can be specified
#  to find less popular definitions.
#  ------------------------
#  Depends on JSON and LWP::Simple for parsing and getting the API respectively.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use LWP::Simple;
use JSON qw(decode_json);

# declarations
my $urban_url = "http://api.urbandictionary.com/v0/define?term=";
my $word;
my $def_count = 0;
my $api_data;
my $decoded_data;
my @definitions;

if ($#ARGV == 0)
{
	$word = shift;
} 
elsif ($#ARGV == 2)
{
	$word = $ARGV[0];
	$def_count = $ARGV[2] - 1;
}
else
{
	&usage();
	exit 0;
}

$urban_url .= $word;

$api_data = get($urban_url) || die "Failed to fetch data.\n";
$decoded_data = decode_json($api_data) || die "Error parsing API.\n";
@definitions = @{$decoded_data->{'list'}};

die "No suitable definition found.\n" unless defined $definitions[$def_count]->{'definition'}; # if no definitions exist

print $definitions[$def_count]->{'definition'}, "\n"; # get the nth definition

sub usage
{
	print "Usage: $0 <word> [-l <number>]\n";
	print "Using $0 with -l outputs the <number>th definitions of <word>\n";
}
