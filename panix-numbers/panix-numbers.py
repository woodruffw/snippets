#!/usr/bin/env python3

#	panix-numbers.py
#	Author: William Woodruff
#	------------------------
#	Get Panix dialup numbers for a given area code.
#	Numbers are scraped from https://www.panix.com/dialup/numbers-public.txt
#	------------------------
#	This code is licensed by William Woodruff under the MIT License.
#	http://opensource.org/licenses/MIT

from sys import argv, exit
from urllib.request import urlopen
import re

if len(argv) != 2 or not re.match('^\d{3}$', argv[1]):
	print('Usage: {0} <area code>'.format(argv[0]))
	exit(1)

res = urlopen('https://www.panix.com/dialup/numbers-public.txt')
lines = res.read().decode('utf-8').split('\n')
res.close()

regex = re.compile('^{0}'.format(argv[1]))

matches = [line for line in lines if regex.match(line)]

if len(matches) != 0:
	print('Number         Location                           Static-IP Shell  Auth Idle Provider')
	print('------------   ------------------------------     --------- ------ ---- ---- --------')
	print('\n'.join(matches))
else:
	print('No results for area code {0}.'.format(argv[1]))
