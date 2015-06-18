#!/usr/bin/env ruby

#	socketslurp.rb
#	Author: William Woodruff
#	------------------------
#	Reads a base64 encoded file from a socket, validating it using a SHA1 hash.
#	Useful for quickly shooting data between two machines.
#	Complemented by socketdump.rb
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

require 'socket'
require 'digest/sha1'
require 'base64'

if ARGV.size != 2
	abort("Usage: #{$0} <hostname> <port>")
end

begin
	sock = TCPSocket.new(ARGV[0], Integer(ARGV[1]))
	hash, filename = sock.gets.split(' ')
	data = sock.read
rescue Exception => e
	abort("Fatal: #{e.to_s}")
end

if hash != Digest::SHA1.hexdigest(data)
	abort("Fatal: hash mismatch for received file.")
else
	File.write(filename, Base64.decode64(data))
end

sock.close
