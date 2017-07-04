#!/usr/bin/env ruby
# frozen_string_literal: true

# mSMTP: a terrible miniature (unencrypted) SMTP server.
# Give it a command to pipe individual emails to.

require "socket"

cmd = ARGV.shift || abort("Usage: msmtp <cmd>")
server = TCPServer.new 25
Process.euid = "nobody" # is this secure?

trap(:INT) { exit! } # lol

def receive_message(client)
  state = :begin
  lines = []
  client.write "220 your.friendly.fake.smtpd SMTP msmtp\r\n"

  until state == :end
    line = client.gets
    case state
    when :begin
      if line =~ /^HELO|EHLO/
        client.write "250 Hello there\r\n"
        state = :helo
      else
        STDERR.puts "! #{state} got #{line}"
        state = :end # expected HELO or EHLO, got something else
      end
    when :helo
      if line =~ /^MAIL FROM/
        client.write "250 Ok\r\n"
        state = :mail_from
      else
        STDERR.puts "! #{state} got #{line}"
        state = :end # expected MAIL FROM, got something else
      end
    when :mail_from
      if line =~ /^RCPT TO/
        client.write "250 Ok\r\n"
        state = :rcpt_to
      else
        STDERR.puts "! #{state} got #{line}"
        state = :end # expected RCPT TO, got something else
      end
    when :rcpt_to
      if line =~ /^DATA/
        client.write "354 End data with <CR><LF>.<CR><LF>\r\n"
        state = :data
      else
        STDERR.puts "! #{state} got #{line}"
        state = :end # expected DATA, got something else
      end
    when :data
      if line =~ /\.\r$/
        client.write "250 Ok"
        state = :end # we don't care about their QUIT message
      else
        lines << line
      end
    end
  end

  lines
ensure
  client&.close
end

loop do
  Thread.new(server.accept) do |client|
    message = receive_message(client).join
    r, w = IO.pipe

    pid = Process.spawn(cmd, in: r.fileno)
    w.puts message
    w.close
    r.close
    pid.wait
  end
end
