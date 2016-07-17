#!/usr/bin/env ruby

#	uspatent.rb
#	Author: William Woodruff
#	------------------------
#	Fetches a filed US patent by number in PDF format.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require "open-uri"

URL = "https://patentimages.storage.googleapis.com/pdfs/%{patent}"

number = ARGV.shift

abort "Usage: #{$PROGRAM_NAME}: <patent #>" if number.nil?

patent = "US#{number}.pdf"
url = URL % { patent: patent }

begin
	open(url) do |url|
		open(patent, "wb") do |file|
			file.write(url.read)
		end
	end
rescue OpenURI::HTTPError => e
	abort "Fatal: #{e.to_s}"
end

