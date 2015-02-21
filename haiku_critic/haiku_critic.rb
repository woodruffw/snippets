#!/usr/bin/env ruby
#
#
#
#

require 'cinch'

require_relative 'haiku_check'

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