#	haiku-check.rb
#	A Cinch plugin that checks for 5-7-5 Haikus.
#	Depends on 'syllabize' for syllable counts.

require 'syllabize'

class HaikuCheck
	include Cinch::Plugin

	listen_to :join, method: :join_message

	def join_message(m)
		if (m.user.nick != @bot.nick)
			m.reply "Welcome. This is a haiku-only channel. Please use the 5 // 7 // 5 haiku form to avoid being kicked.", true
		end
	end

	listen_to :channel, method: :check_line, strip_colors: true

	def check_line(m)
		lines = m.message.split('//')
		line_counts = lines.map { |line| line.count_syllables }

		if lines.size != 3 || line_counts[0] != line_counts[2] || line_counts[1] != 7
			m.reply "Please follow the 5 // 7 // 5 haiku form.", true
			m.channel.kick(m.user, "Please follow the 5 // 7 // 5 haiku form.")
		end
	end
end
