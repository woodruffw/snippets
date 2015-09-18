/*	jellybean_trigger.c
	Author: Rogach, William Woodruff
	------------------------
	Uses libesd (ALSA) to monitor a jellybean button, executing a command
	when the button is pushed.
	Modified from https://github.com/Rogach/piano-pedal-driver
	------------------------
	The original does not appear to be under any license, so this one will
	remain in the public domain.
*/

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <esd.h>
#include <fcntl.h>

#define MIN_THRESH 120
#define MAX_THRESH 127
#define IN_THRESH(n) ((n <= MAX_THRESH) && (n >= MIN_THRESH))

int jellybean(char **cmd);

int main(int argc, char **argv)
{
	int rc;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s <command [arg ...]>\n", argv[0]);
		return 1;
	}

	rc = jellybean(argv + 1);

	return rc;
}

int jellybean(char **cmd)
{
	int esd_socket = 0;
	esd_format_t format = ESD_BITS16 | ESD_STEREO | ESD_STREAM | ESD_MONITOR;
	
	while (esd_socket == 0) {
		esd_socket = esd_record_stream_fallback(format, 1000, NULL, "ppd");

		if (esd_socket < 0) {
			fprintf(stderr, "Fatal: Failed to open ESD socket.\n");
			return 1;
		}
		if (esd_socket == 0) {
			fprintf(stderr, "Error: ESD not ready: got socket #0.\n");
			close(esd_socket);
			sleep(3);
		}
	}

	if (fcntl(esd_socket, F_SETFL, O_NONBLOCK) == -1) {
		fprintf(stderr, "Fatal: Failed to set socket to non-blocking mode.\n");
		return 1;
	}

	while (1) {
		unsigned char buffer[1024*64];
		int nbytes, peaks, i;
		pid_t pid;

		usleep(10000);

		nbytes = read(esd_socket, buffer, sizeof(buffer));

		for (i = 1; i < nbytes; i += 2) {
			if (IN_THRESH(buffer[i])) {
				peaks++;
			}
		}

		if (peaks > 65) {
			switch (pid = fork()) {
				case 0:
					if (execvp(cmd[0], cmd) < 0) {
						fprintf(stderr, "Error: Could not exec %s.\n", cmd[0]);
					}
					break;
				case -1:
					fprintf(stderr, "Fatal: Could not fork().\n");
					return 1;
			}
		}

		peaks = 0;
	}

	close(esd_socket);

	return 0;
}
