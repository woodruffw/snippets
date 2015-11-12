#!/usr/bin/env ruby

#	email-fwd.rb
#	Author: William Woodruff
#	------------------------
#	A quick and dirty email forwarder. Reads addresses and credentials from
#	~/.email-fwd, forwarding all unseen messages onto the specified address in
#	raw form. Doesn't like HTML very much.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'net/imap'
require 'net/smtp'
require 'yaml'

class String
	def unindent
		gsub(/^#{scan(/^[ \t]+(?=\S)/).min}/, '')
	end
end

fwd = File.expand_path("~/.email-fwd")

abort('Fatal: No ~/.email-fwd to load from. Exiting.') unless File.file?(fwd)

hash = YAML::load_file(fwd)
forward = hash['forward_to']

hash['emails'].each do |email, data|
	imap = Net::IMAP.new(data['imap'], { ssl: { verify_mode: 0 }})

	imap.login(email, data['pass'])
	imap.select('INBOX')

	unreads = imap.search('UNSEEN')

	if unreads.size > 0
		imap.store(unreads, '+FLAGS', [:Seen])

		attributes = imap.fetch(unreads, ['ENVELOPE', 'BODY.PEEK[]'])

		attributes.each do |m|
			envelope = m.attr['ENVELOPE']
			text = m.attr['BODY[]']

			smtp = Net::SMTP.new(data['smtp'], 25)
			smtp.enable_starttls_auto
			smtp.start("localhost", email, data['pass'], (data['auth'] || 'plain').to_sym)

			msg = <<-EOF.unindent
				From: #{email}
				To: #{forward}
				Subject: Fwd: #{envelope.subject}
				X-Forwarding-Method: fwd.rb

				Begin forwarded message:

				#{text}
			EOF

			smtp.send_message msg, email, forward
			smtp.finish
		end
	end

	imap.logout
	imap.disconnect

	puts "Forwarded #{unreads.size} messages from #{email}."
end
