#!/usr/bin/env ruby

#	image-bork.rb
#	Author: William Woodruff
#	------------------------
#	Bork an image by repeatedly applying various filters and effects to it.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'rmagick'

methods = [
	['adaptive_threshold', 3, 3, 0],
	['threshold', 255 * 0.55],
	['edge', 0],
	['ordered_dither', '2x2'],
	['posterize', 4, false],
	['roll', 150, 150],
	['shade', true, 30, 30]
]

file, level = ARGV.shift(2)

if level.nil?
	level = 10
else
	level = Integer(level)
end

if file.nil?
	puts "Usage: #{$PROGRAM_NAME} <image> [bork level]"
	exit 1
end

in_image = Magick::Image.read(file).first
out_image = in_image.dup

level.times do
	out_image = out_image.send(*methods.sample)
end

out_image.write('bork.png')
