#!/usr/bin/env ruby

#	images-glitch.rb
#	Author: William Woodruff
#	------------------------
#	'Glitch' multiple images together by repeatedly compositing them at various
#	coordinates and in various fashions.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'rmagick'

if ARGV.size < 3
	puts "Usage: #{$PROGRAM_NAME} <glitch level> <file1 file2 [file3 ...]>"
	exit 1
end

composite_operators = [
	Magick::AddCompositeOp,
	Magick::AtopCompositeOp,
	Magick::BumpmapCompositeOp,
	Magick::ColorBurnCompositeOp,
	Magick::ColorDodgeCompositeOp,
	Magick::ColorizeCompositeOp,
	Magick::HardLightCompositeOp,
	Magick::HueCompositeOp,
	Magick::InCompositeOp,
	Magick::LightenCompositeOp,
	Magick::LinearBurnCompositeOp,
	Magick::LinearDodgeCompositeOp,
	Magick::LinearLightCompositeOp,
	Magick::LuminizeCompositeOp,
	Magick::MultiplyCompositeOp,
	Magick::PegtopLightCompositeOp,
	Magick::PinLightCompositeOp,
	Magick::PlusCompositeOp,
	Magick::ReplaceCompositeOp,
	Magick::SaturateCompositeOp,
	Magick::SoftLightCompositeOp,
	Magick::VividLightCompositeOp,
	Magick::XorCompositeOp
]

level = Integer(ARGV.shift)

in_images = ARGV.map do |file|
	Magick::Image.read(file).first
end

out_image = in_images.first

in_images.each do |image|
	if (image.rows * image.columns) > (out_image.rows * out_image.columns)
		out_image = image
	end
end

width = out_image.columns
height = out_image.rows

level.times do
	start_x = rand(0...width)
	start_y = rand(0...height)

	case rand(1..4)
	when 1
		out_image.composite!(in_images.sample, start_x, start_y, composite_operators.sample)
	when 2
		out_image.composite!(in_images.sample, -start_x, start_y, composite_operators.sample)
	when 3
		out_image.composite!(in_images.sample, start_x, -start_y, composite_operators.sample)
	when 4
		out_image.composite!(in_images.sample, -start_x, -start_y, composite_operators.sample)
	end
end

out_image.write('glitch.png')
