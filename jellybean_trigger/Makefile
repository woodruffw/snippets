CC = cc
CFLAGS = -std=c99 -O3
CPPFLAGS = -D_BSD_SOURCE
LDFLAGS = -lesd -o jellybean_trigger

all:
	$(CC) $(CFLAGS) $(CPPFLAGS) jellybean_trigger.c $(LDFLAGS)

clean:
	rm -rf jellybean_trigger

.PHONY: all clean
