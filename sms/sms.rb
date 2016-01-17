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
providers = {
	"usc" => "%{number}@email.uscc.net",
    "alltel" => "%{number}@message.alltel.com",
    "ting" => "%{number}@message.ting.com",
    "spring" => "%{number}@messaging.sprintpcs.com",
    "cellone" => "%{number}@mobile.celloneusa.com",
    "telus" => "%{number}@msg.telus.com",
    "acs" => "%{number}@paging.acswireless.com",
    "rogers" => "%{number}@pcs.rogers.com",
    "qwest" => "%{number}@qwestmp.com",
    "tmobile" => "%{number}@tmomail.net",
    "att" => "%{number}@mms.att.net",
    "verizon" => "%{number}@vzwpix.com",
    "republic" => "%{number}@text.republicwireless.com",
    "cricket" => "%{number}@mms.cricketwireless.net",
    "virgin" => "%{number}@vmobl.com"
}

provider, number = ARGV.shift(2)

if number.nil? || number !~ /\d{9,10}/ || providers[provider].nil?
	puts "Usage: #{$PROGRAM_NAME} <provider> <phone number>"
	puts "Providers are #{providers.keys.join(', ')}."
	exit 1
end

Mail.defaults do
	delivery_method :smtp, opts
end

message = STDIN.read

address = providers[provider] % { number: number }

Mail.new do
	from conf["email"]
	to address
	body message
end.deliver!
