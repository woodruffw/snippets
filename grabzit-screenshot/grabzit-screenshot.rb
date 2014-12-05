#!/usr/bin/env ruby

#  grabzit-screenshot.rb
#  Author: William Woodruff
#  ------------------------
#  Takes a screenshot of the given website, saving it to the given file.
#  Uses Grabzit's API for the actual screenshotting, which sucks.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'grabzit'

unless ARGV.length == 2
	puts "Usage: $0 <url> <file>\n"
	exit 1
end

client = GrabzIt::Client.new(ENV['GRABZIT_API_KEY'], ENV['GRABZIT_API_SECRET'])
url = ARGV.shift
file = ARGV.shift
client.set_image_options(url)
client.save_to(file)
