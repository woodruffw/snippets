#!/usr/bin/env ruby

#	sms.rb
#	Author: William Woodruff
#	------------------------
#	Sends SMS/MMS messages using SMTP gateways provided by cellular companies.
#	Supports most large (US) cellular providers, reads messages from stdin.
#	Reads SMTP credentials and information from ~/.smsrc.
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require "yaml"

begin
	require "mail"
rescue LoadError
	abort("Fatal: The 'mail' gem is required.")
end

smsrc = File.expand_path("~/.smsrc")
abort("Fatal: No ~/.smsrc found.") unless File.file?(smsrc)

conf = YAML::load_file(smsrc)
opts = {
	address: conf["smtp"],
	port: 587,
	user_name: conf["email"],
	password: conf["password"],
	authentication: conf["auth"],
	enable_starttls_auto: true
}

# prefer mms where available
providers = [
	"%{number}@email.uscc.net",
	"%{number}@message.alltel.com",
	"%{number}@message.ting.com",
	"%{number}@messaging.sprintpcs.com",
	"%{number}@mobile.celloneusa.com",
	"%{number}@msg.telus.com",
	"%{number}@paging.acswireless.com",
	"%{number}@pcs.rogers.com",
	"%{number}@qwestmp.com",
	"%{number}@tmomail.net",
	"%{number}@mms.att.net",
	"%{number}@vzwpix.com",
	"%{number}@text.republicwireless.com",
	"%{number}@mms.cricketwireless.net",
	"%{number}@vmobl.com"
]

number = ARGV.shift

if number.nil? || number !~ /\d{9,10}/
	abort("Usage: #{$PROGRAM_NAME} <phone number>")
end

Mail.defaults do
	delivery_method :smtp, opts
end

message = STDIN.read

addresses = providers.map { |p| p % { number: number } }
threads = []

addresses.each do |address|
	threads << Thread.new do
		Mail.new do
			from conf["email"]
			to address
			body message
		end.deliver!
	end
end

threads.each(&:join)
