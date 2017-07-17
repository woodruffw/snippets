#!/usr/bin/env perl

#  mk-qrcode.pl
#  Author: William Woodruff
#  ------------------------
#  Generates a QR code from textual user input.
#  Depends upon Imager::QRCode.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use Imager::QRCode;

my $size = shift || die "Usage: $0 <module size> <text>\n";
my $data = shift || die "Usage: $0 <size> <text>\n";

my $qr = Imager::QRCode->new(size => $size, level => 'H', casesensitive => 1);

my $img = $qr->plot($data);
$img->write(file => "qr.png");