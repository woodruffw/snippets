#!/usr/bin/env ruby

#	umd-arrest-ledger.rb
#	Author: William Woodruff
#	------------------------
#	Fetch UMD arrest records for the given year and dump them as JSON.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'open-uri'
require 'nokogiri'
require 'json'

URL = 'http://www.umpd.umd.edu/stats/arrest_report.cfm?year=%{year}'

year = ARGV.shift.to_i

# ledgers before 11/2010 used a different format
if year.nil? || !year.between?(2011, Time.now.year)
	abort("Usage: #{$PROGRAM_NAME} <year>")
end

data = {}
url = URL % { year: year }

html = Nokogiri::HTML(open(url).read)
trs = html.css('table').first.css('tr')
trs.shift # remove the description <tr>

trs.each_slice(2) do |tr0, tr1|
	# i am not proud of this.
	entry = tr0.css('td').to_a.concat(tr1.css('td').to_a).map(&:text).map(&:strip)

	data[entry[0]] = {
		arrest_time: entry[1],
		case_number: entry[2],
		age: entry[3],
		race: entry[4],
		sex: entry[5],
		charge: entry[6]
	}
end

File.open("#{year}.json", "w") do |file|
	file.write(JSON.pretty_generate(data))
end

