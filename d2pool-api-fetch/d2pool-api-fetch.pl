#!/usr/bin/perl

#  d2pool-api-fetch.pl
#  Author: William Woodruff
#  ------------------------
#  Fetches data associated with an API key from ftc.d2.cc's JSON API.
#  Depends on LWP::UserAgent, HTTP:Request, File::HomeDir, Try::Tiny, and JSON.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request;
use File::HomeDir;
use Try::Tiny;
use JSON qw(decode_json);

my $d2pool_url = "https://ftc.d2.cc/api.php?api_key=";
my $api_key;
my $config_file = File::HomeDir->my_home . "/.d2pool-fetch-api";

if (-e $config_file) 
{
 	open my $file, '<', $config_file;
 	$api_key = <$file>;
 	close $file;
}
else
{
	$api_key = shift || die "Usage: $0 [api-key]\nAlternatively, put the key in ~/.d2-fetch-api\n";
}

$d2pool_url .= $api_key;

my $user_agent = LWP::UserAgent->new(agent => "Firefox"); # the API disallows Perl's UA, so fake it
my $response = $user_agent->get($d2pool_url);
my $json_data = $response->content;
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
