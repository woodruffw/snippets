#!/usr/bin/env perl

#  randomimage.pl
#  Author: William Woodruff
#  ------------------------
#  Generates a pseudorandom image.
#  Requires ImageMagick to perform image operations.
#  ------------------------
#  Usage:
#  randomimage.pl [width] [height]
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use Image::Magick;

my $dim = ((shift || 512) . "x" . (shift || 512));

my $image = Image::Magick->new;
$image->Set(size=>$dim);
$image->ReadImage('canvas:white');

my @color;

for (my $i = 0; $i < $image->Get('width'); $i++) {
	for (my $j = 0; $j < $image->Get('height'); $j++) {
		for (my $k = 0; $k < 3; $k++)
		{
			$color[$k] = int(rand(1000))/1000;
		}

		$image->SetPixel(x=>$i, y=>$j, color=>\@color);
	}
}

$image->Write(filename=>'random.png', compression=>'None');