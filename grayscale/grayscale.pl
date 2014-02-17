#!/usr/bin/env perl

#  grayscale.pl
#  Author: William Woodruff
#  ------------------------
#  Grayscales the given image and saves it as grayscale.png.
#  Requires ImageMagick to perform image operations.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use Image::Magick;

my $image = Image::Magick->new;
open(IMAGE, shift || die "Usage: grayscale.pl [image]\n");
$image->Read(file=>\*IMAGE);
close(IMAGE);

$image->Quantize(colorspace=>'gray');

$image->Write(filename=>'grayscale.png', compression=>'None');
