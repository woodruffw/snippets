#!/usr/bin/env ruby

#	socketdump.rb
#	Author: William Woodruff
#	------------------------
#	Dumps a file into a socket, base64 encoded and headed by a hash and name.
#	Useful for quickly shooting data between two machines.
#	Complemented by socketslurp.rb
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'socket'
require 'digest/sha1'
require 'base64'

if ARGV.size != 2
	abort("Usage: #{$0}: <port> <file>")
end

begin
	port = Integer(ARGV[0])
	data = Base64.encode64(open(ARGV[1]).read)
	hash = Digest::SHA1.hexdigest(data)
rescue Exception => e
	abort("Fatal: #{e.to_s}")
end

server = TCPServer.new(port)

loop do
	Thread.start(server.accept) do |client|
		client.puts("#{hash} #{File.basename(ARGV[1])}")
		client.puts(data)
		client.close
	end
end
