#!/usr/bin/env ruby

#	umd-incident-logs.rb
#	Author: William Woodruff
#	------------------------
#	Fetch UMD crime and incident logs for the given month and year and dump
#	them as JSON.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'open-uri'
require 'nokogiri'
require 'json'

URL = 'http://www.umpd.umd.edu/stats/incident_logs.cfm?year=%{year}&month=%{month}'

now = Time.now
month, year = ARGV.shift(2).map(&:to_i)

if month.nil? || year.nil?
	abort("Usage: #{$PROGRAM_NAME} <month> <year>")
end

# reports before 11/2010 used a different format
if !(month.between?(11, 12) && year == 2010) &&
	!(month.between?(1, now.month) && year == now.year) &&
	!(month.between?(1, 12) && year.between?(2011, now.year - 1))

	abort("Data is only available between 11/2010 and the current month.")
end

data = {}
url = URL % { year: year, month: month }

html = Nokogiri::HTML(open(url).read)
trs = html.css('table').first.css('tr')
trs.shift # remove the description <tr>

trs.each_slice(2) do |tr0, tr1|
	# i am not proud of this.
	entry = tr0.css('td').to_a.concat(tr1.css('td').to_a).map(&:text).map(&:strip)

	data[entry[0]] = {
		occurred_date: entry[1],
		report_date: entry[2],
		type: entry[3],
		disposition: entry[4],
		location: entry[5]
	}
end

File.open("#{month}-#{year}.json", "w") do |file|
	file.write(JSON.pretty_generate(data))
end

