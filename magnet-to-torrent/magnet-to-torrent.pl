#!/usr/bin/env perl

#  magnet-to-torrent.pl
#  Author: William Woodruff
#  ------------------------
#  Converts the provided magnet link into a usable torrent file (with a semiunique name) using magnet2torrent.com.
#  Note: magnet2torrent.com's owners may not appreciate bulk transactions through their website. Use sparingly, or ask first.
#  Depends on WWW::Mechanize for form submission.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use WWW::Mechanize;

my $magnet = shift || die "Usage: magnet-to-torrent.pl <\"magnet link\">\n";
my $url = 'http://magnet2torrent.com/';
my $mech = WWW::Mechanize->new(agent => 'magnet-to-torrent/perl/iamarobot', ssl_opts => {SSL_verify_mode => qw/IO::Socket::SSL::SSL_VERIFY_NONE/, verify_hostname => 0});
$mech->get($url);

my $result = $mech->submit_form(form_number => 1, fields => { magnet => $magnet });
my @links = $mech->links();

$mech = WWW::Mechanize->new(agent => 'magnet-to-torrent/perl/iamarobot', ssl_opts => {SSL_verify_mode => qw/IO::Socket::SSL::SSL_VERIFY_NONE/, verify_hostname => 0});
$mech->get($links[7]->url());
$mech->save_content(time() . 'x' . rand() . '.torrent');
