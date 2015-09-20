#!/usr/bin/env ruby

#	sdate.rb
#	Author: William Woodruff
#	------------------------
#	Prints today's Eternal September date in asctime format.
#	Fun fact: this preamble is 4 times longer than the actual code.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

day = ((Time.now - Time.new(1993, 9, 1)) / 86400).to_i
puts Time.now.strftime "%a %b #{day} %T 1993"
