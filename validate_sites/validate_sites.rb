#!/usr/bin/env ruby

#	validate_sites.rb
#	Author: William Woodruff
#	------------------------
#	Reads a newline-delimited stream of website addresses from stdin,
#	testing each's markup validity using the Nu HTML Validator (vnu.jar).
#	Output takes the format: <siteurl> <warning count> <error count>
#	Releases can be found at:
#	https://github.com/validator/validator/releases/tag/15.4.12
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'json'

if !File.exist?("vnu.jar")
	abort("Fatal: Could not find a vnu.jar to validate with.")
end

ARGF.each_line do |site|
	site.chomp!
	
	begin
		output = JSON.parse(`java -jar vnu.jar --format json #{site} 2>&1`)

		wc = output["messages"].select { |m| m["subType"] == "warning" }.size
		ec = output["messages"].select { |m| m["type"] == "error" }.size
	rescue Exception => e
		wc = '?'
		ec = '?'
	end
	
	puts "#{site} #{wc} #{ec}"
end
