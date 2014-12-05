#!/usr/bin/env ruby

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
