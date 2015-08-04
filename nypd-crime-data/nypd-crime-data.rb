#!/usr/bin/env ruby

#	nypd-crime-data.rb
#	Author: William Woodruff
#	------------------------
#	Fetches aggregated crime data from each NYPD precinct in PDF format.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require "open-uri"

# http://www.nyc.gov/html/nypd/html/home/precincts.shtml
precincts = [
	1, *5..7, 9, 10, 13, 14, *17..20, *22..26, 28, 30, *32..34, *40..50, 52,
	*60..63, *66..73, *75..79, 81, 83, 84, 88, 90, 94, *100..115, *120..123
].map! { |p| "%03d" % p }

url = "http://www.nyc.gov/html/nypd/downloads/pdf/crime_statistics/cs-en-us-%{num}pct.pdf"

precincts.each do |pct|
	print "Saving #{pct}.pdf..."
	open("#{pct}.pdf", "wb") do |file|
		open(url % { :num => pct }) do |url|
			file.write(url.read)
		end
	end
	puts "done."
end
