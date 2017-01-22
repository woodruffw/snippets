#!/usr/bin/env python2.7

#   author: rmNULL
#   License: https://opensource.org/licenses/MIT
#
#   brightness.py
#       a simple utility to manage brightness of macbook's display (might work
#       for other (intel) devices too(I haven't tested). This
#       tool is inspired from hobarrera's kbdlight (https://github.com/hobarrera/kbdlight)

#   Note: the changes made to the brightness are relative.
#   TODO: maybe rename it to display_stat or bright or something?

import sys

def usage():
    print "usage: %s [up [<percentage>] || down [<percentage>] || off || max || get || set <value>]" % sys.argv[0]
    sys.exit(0)

def main(args):
    bn_dir = "/sys/class/backlight/intel_backlight/"
    bn_file = bn_dir + "brightness"
    max_bn_file = bn_dir + "max_brightness"

    try:
        with open(bn_file, 'r') as fh:
            tmp = int(fh.readline().strip())
        current = 100 if tmp == 0 else tmp
    except IOError:
        sys.stderr.write("failed to open %s\n" % bn_file)
        sys.exit(1)
    
    
    if args[0] == "up" or args[0] == "down":
        try:
            percent = int(args[1])
            if percent < 0 or percent > 100:
                raise ValueError
        except ValueError:
            sys.stdout.write("value must be a number between 0 and 100.\n")
            usage()
        except IndexError:
            percent = 10

	change = (current * percent) / 100
    elif args[0] == "off":
        change = -int(current)
    elif args[0] == "max":
        try:
            with open(max_bn_file, 'r') as fh:
                top = int(fh.readline().strip())
        except IOError:
            top = 100

        change = top - current
    elif args[0] == "get":
        print "brightness: %s" % current
        sys.exit(0)
    elif args[0] == "set":
	try:
	    change = int(args[1])
	except IndexError:
	    usage()
	    # not sure how good idea this is (using xrange to check bounds)
	    if not change in xrange(101):
		sys.stdout.write("value must be a number between 0 and 100.\n")
		usage()
        current = 0 # normalize
    else:
        usage()

    if args[0] == "down":
        change *= -1;

    print current + change
    new = current + change if current + change < 100 else 100

    try:
        with open(bn_file, 'w') as fh:
            fh.write(str(new))
    except IOError:
        sys.stderr.write("Operation not permitted: cannot write to %s\n" % bn_file)
        sys.exit(1)

if __name__ == "__main__":

    args = sys.argv[1:]
    if (len(args) == 0):
        usage()

    main(args)
