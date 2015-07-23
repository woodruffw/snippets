#!/usr/bin/env ruby

#	fortune500.rb
#	Author: William Woodruff
#	------------------------
#	Scrapes the Fortune 500 companies from uspages.com for their company
#	websites. Uses Nokogiri and dumps them to stdout.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

base_url = "http://www.uspages.com"

main_page = Nokogiri::HTML(open("#{base_url}/fortune500.htm").read)

main_page.css('ol').each do |ol|
	ol.css('a').each do |a|
		href = a.attributes['href']
		
		comp_page = Nokogiri::HTML(open("#{base_url}/#{href}").read)

		info = comp_page.css('div#main').css('ul#meta').css('li[class=contact]')
		
		info.css('ul').first.css('li').each do |li|
			if li.text =~ /^Website:/
				puts li.css('a').first.text
			end
		end
	end
end
