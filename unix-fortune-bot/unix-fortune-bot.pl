#!/usr/bin/env perl

use strict;
use warnings;

use Net::Twitter;

my $consumer_key = "neuRWy8PqGL91G05pXBoLw";
my $consumer_secret = "LGwogxioLgtFYYSyUeM0HuVUXuOmr0YejBwxjA6jU";
my $token = "2388188923-MrXlC08xUG7HQs1vR0ASZgV0jyLjxtptp4wW0en";
my $token_secret = "IjfGDJr3DxQBQci3oM10u136pj5NRStNuRmdfmCUoHPOZ";

my $twitter = Net::Twitter->new(traits => [qw/API::RESTv1_1/], consumer_key => $consumer_key, consumer_secret => $consumer_secret, access_token => $token, access_token_secret => $token_secret, ssl => 1);

while (1)
{
	my $fortune = `fortune -s -n 140`;
	my $result = $twitter->update($fortune);
	sleep(900);
}
