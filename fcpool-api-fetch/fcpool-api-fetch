#!/usr/bin/perl

#  fcpool-api-fetch.pl
#  Author: William Woodruff
#  ------------------------
#  Fetches data associated with an API key from FCPool.com's JSON API.
#  Depends on LWP::Simple, File::HomeDir, Try::Tiny, and JSON.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use LWP::Simple;
use File::HomeDir;
use Try::Tiny;
use JSON qw(decode_json);

my $fcpool_url = "http://fcpool.com/api?api_key=";
my $api_key;
my $config_file = File::HomeDir->my_home . "/.fcpool-fetch-api";

if (-e $config_file) 
{
 	open my $file, '<', $config_file;
 	$api_key = <$file>;
 	close $file;
}
elsif ($#ARGV == 0)
{
	$api_key = shift || die print "Usage: $0 <api-key>\nAlternatively, put the key in ~/.fcpool-fetch-api\n";
}

$fcpool_url .= $api_key;

my $json_data = get($fcpool_url);
	die "Error: API Key not found.\n" unless defined $json_data;

my $decoded_json_data;

try
{
	$decoded_json_data = decode_json($json_data);
}
catch
{
	die "Error parsing JSON data.\n";
};

print "Username: ", $decoded_json_data->{"username"}, "\n";
print "FeatherCoins Earned: ", $decoded_json_data->{"confirmed_rewards"}, "\n";
print "Hashrate: ", $decoded_json_data->{"total_hashrate"}, " KHashes/sec", "\n";
