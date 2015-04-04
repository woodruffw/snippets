#!/usr/bin/env ruby

#	cloud2butt-irc.rb
#	Author: William Woodruff
#	------------------------
#	An IRC version of the Cloud2Butt browser plugin.
#	Matches any message containing 'cloud' (case-insensitive), substituting
#	each 'cloud' for 'butt'.
#	Usage: ruby cloud2butt-irc.rb <server> <'#chan1,#chan2,...''>
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'cinch'

$BOTNAME = 'cloud2butt'
$TRIGGER = 'cloud'

bot = Cinch::Bot.new do
	configure do |c|
		c.nick = $BOTNAME
		c.realname = $BOTNAME
		c.max_messages = 1
		c.server = ARGV[0]
		c.channels = ARGV[1].split(',')
	end

	on :message, /#{$TRIGGER}/i do |m|
		m.reply m.message.gsub(/#{$TRIGGER}/i, 'butt')
	end

	on :message, /^[.!:]source$/ do |m|
		m.reply 'https://github.com/woodruffw/snippets/blob/master/cloud2butt-irc/cloud2butt-irc.rb'
	end
end

bot.start
