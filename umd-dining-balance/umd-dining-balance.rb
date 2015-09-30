#!/usr/bin/env ruby

#	umd-dining-balance.rb
#	Author: William Woodruff
#	------------------------
#	Fetch UMD dining plan balance data for a given student, by Directory ID.
#	Uses Mechanize and Nokogiri.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'mechanize'
require 'nokogiri'

URL = 'https://login.umd.edu/cas/login?service=http://dsonline.umd.edu/dsbalance/'

if ARGV.length != 2
	abort("Usage: #{$PROGRAM_NAME} <username> <password>")
end

username, password = ARGV.shift(2)
mech = Mechanize.new
page = mech.get(URL)
form = page.forms.first

form.field_with(name: 'username').value = username
form.field_with(name: 'password').value = password

html = Nokogiri::HTML(mech.submit(form).body)

if html.css('table').empty?
	abort('Fatal: Failed to login through CAS. Check your credentials.')
end

table = html.css('table').first.css('table')[1]

output = table.css('tr').map do |r|
	r.css('td').map(&:text).map(&:lstrip).join
end.select { |e| e != "\u00A0" }

output.each { |e| puts e.sub(' : ', ': ') }
