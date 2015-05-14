#!/usr/bin/env ruby

#	ibip-check.rb
#	A simple Cinch IRC bot that scans a channel for IBIP-compliant bots and
#	reports on them.
#	Author: William Woodruff
# 	------------------------
# 	This code is licensed by William Woodruff under the MIT License.
# 	http://opensource.org/licenses/MIT

require 'cinch'

hash = {}

Cinch::Bot.new do
	configure do |c|
		c.nick = 'ibip-check'
		c.realname = 'ibip-check'
		c.max_messages = 1
		c.server = ARGV.shift
		c.channels = [ARGV.shift]
	end
	
	on :message, /^.bots$/ do |m|
		m.reply "Reporting in! [Ruby] %ibip <nick> lists information for a bot."
	end
	
	on :message, /^Reporting in! (.+)/ do |m, data|
		hash[m.user.nick] = data
	end
	
	on :message, /^%ibip$/ do |m|
		unless hash.empty?
			m.reply "I\'ve seen #{hash.size} bots so far, not including myself.", true
		else
			m.reply "I haven\'t seen any bots yet. Try running .bots.", true
		end
	end
	
	on :message, /^%ibip (\S+)/ do |m, nick|
		if hash.has_key?(nick)
			data = hash[nick]
			lang = data[/\[(.+)\]/, 1]
			more = data[/(?:\[.+\]) (.+)/, 1]
			
			if lang && more
				m.reply "#{nick} is written in #{lang} and says \'#{more}\'", true
			elsif lang
				m.reply "#{nick} is written in #{lang}.", true
			elsif more
				m.reply "#{nick} did not provide a language but says \'#{more}\'", true
			else
				m.reply "#{nick} responded to .bots, but provides no extra information.", true
			end
		else
			m.reply "I don\'t have a response from #{nick}.", true
		end
	end
end.start
