#!/usr/bin/env ruby

#	phishbot.rb
#	A bot that listens for PRIVMSGs and reports them to a channel. Nothing more.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'cinch'

network, nick, channel = ARGV.shift(3)

ignore = ['Global', 'peer', 'py-ctcp'] # ignore these Rizon bots/announcers

Cinch::Bot.new do
	configure do |c|
		c.prefix = //
		c.nick = nick
		c.realname = nick
		c.max_messages = 1
		c.server = network
		c.channels = [channel]
	end

	on :private, /(.*)/ do |m, msg|
		if msg && m.user && !ignore.include?(m.user.nick)
			Channel(channel).send "Received \'#{msg}\' from #{m.user.nick}."
		end
	end
end.start
