#!/usr/bin/env ruby

#	haiku-critic.rb
#	A simple Cinch IRC bot that checks whether or not each message is a Haiku.
#	Author: William Woodruff
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'cinch'

require_relative 'haiku-check'

Cinch::Bot.new do
	configure do |c|
		c.nick = 'HaikuCritic'
		c.realname = 'HaikuCritic'
		c.max_messages = 1
		c.server = ARGV[0]
		c.channels = ARGV[1].split(',')
		c.plugins.plugins = [HaikuCheck]
	end
end.start
