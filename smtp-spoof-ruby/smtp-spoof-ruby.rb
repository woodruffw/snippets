#!/usr/bin/env ruby

#	smtp-spoof-ruby.rb
#	Author: William Woodruff
#	------------------------
#	A basic SMTP email spoofer, rewritten in Ruby.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'time'
require 'socket'
require 'dnsruby'

include Dnsruby

def prompt(str)
    print str
    gets.strip
end

from_addr = prompt '"Sender": '
reply_to = prompt 'Reply-To: '
to_addr = prompt 'Recipient: '

begin
	mx_domain = Dnsruby::Resolver.new.query(to_addr.split('@').last, Types.MX).answer[0].exchange.to_s
rescue
	puts "Fatal error in resolving recipient domain. Exiting."
	exit false
end

subject = prompt 'Subject: '

puts '##### Complete message with EOF (^D) #####'
message = STDIN.read

sock = TCPSocket.new mx_domain, 25

sock.recvfrom 1024
sock.send "HELO notreal.com\r\n", 0
sock.recvfrom 1024
sock.send "MAIL FROM:<#{from_addr}>\r\n", 0
sock.recvfrom 1024
sock.send "RCPT TO:<#{to_addr}>\r\n", 0
sock.recvfrom 1024
sock.send "DATA\r\n", 0
sock.send "From: \"#{from_addr}\" <#{from_addr}>\r\n", 0
sock.send "To: \"#{to_addr}\" <#{to_addr}>\r\n", 0
sock.send "Date: #{Time.now.rfc2822}\r\n", 0
sock.send "Subject: #{subject}\r\n", 0
sock.send "Reply-To: \"#{reply_to}\"\r\n", 0
sock.send "#{message}\r\n", 0
sock.send ".\r\n", 0
sock.recvfrom 1024
sock.send "QUIT\r\n", 0
sock.close
