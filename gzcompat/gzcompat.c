/*	gzcompat.c
	Author: Michael Sokolov, Quasijarus Project
	Converts Quasijarius strong compressed files into gzip archives.
	Syntax: ./gzcompat < archive.Z > archive.gz
*/

#ifndef lint
static char sccsid[] = "@(#)gzcompat.c  5.1 (Berkeley) 1/21/99";
#endif

/* gzcompat converts between compress -s and gzip formats. */

#include <stdio.h>

char magic_strong[2] = {037, 0241};
char magic_gzip[2]   = {037, 0213};

struct gzheader {
        unsigned char cm;
        unsigned char flg;
        unsigned char mtime[4];
        unsigned char xfl;
        unsigned char os;
} gzheader;

#define CM_DEFLATE 0x08

#define FTEXT    0x01
#define FHCRC    0x02
#define FEXTRA   0x04
#define FNAME    0x08
#define FCOMMENT 0x10
#define FRSVD    0xE0

#define OS_UNIX 0x03

int main()
{
        char buf[4096];
        int len;
        int mkgzip;

        /* First read the input magic number. */
        len = fread(buf, 1, 2, stdin);
        if (len < 0) {
                perror("stdin");
                return 1;
        }
        if (len != 2) {
                fprintf(stderr, "stdin: not in compress -s or gzip format\n");
                return 1;
        }
        if (buf[0] == magic_strong[0] && buf[1] == magic_strong[1])
                mkgzip = 1;
        else if (buf[0] == magic_gzip[0] && buf[1] == magic_gzip[1])
                mkgzip = 0;
        else {
                fprintf(stderr, "stdin: not in compress -s or gzip format\n");
                return 1;
        }

        /* Now read and check the gzip header if necessary. */
        if (!mkgzip) {
                len = fread(&gzheader, sizeof(struct gzheader), 1, stdin);
                if (len < 0) {
                        perror("stdin");
                        return 1;
                }
                if (len != 1) {
                        fprintf(stderr, "stdin: invalid gzip header\n");
                        return 1;
                }
                if (gzheader.cm != CM_DEFLATE || gzheader.flg & FRSVD) {
                        fprintf(stderr, "stdin: invalid gzip header\n");
                        return 1;
                }
                if (gzheader.flg & FEXTRA) {
                        int count;

                        count = getchar();
                        if (ferror(stdin)) {
                                perror("stdin");
                                return 1;
                        }
                        if (feof(stdin)) {
                                fprintf(stderr, "stdin: invalid gzip header\n");

                                return 1;
                        }
                        while (count) {
                                getchar();
                                if (ferror(stdin)) {
                                        perror("stdin");
                                        return 1;
                                }
                                if (feof(stdin)) {
                                        fprintf(stderr, "stdin: invalid gzip header\n");
                                        return 1;
                                }
                                count--;
                        }
                }
                if (gzheader.flg & FNAME) {
                        int ch;

                        do {
                                ch = getchar();
                                if (ferror(stdin)) {
                                        perror("stdin");
                                        return 1;
                                }
                                if (feof(stdin)) {
                                        fprintf(stderr, "stdin: invalid gzip header\n");
                                        return 1;
                                }
                        }
                        while (ch);
                }
                if (gzheader.flg & FCOMMENT) {
                        int ch;

                        do {
                                ch = getchar();
                                if (ferror(stdin)) {
                                        perror("stdin");
                                        return 1;
                                }
                                if (feof(stdin)) {
                                        fprintf(stderr, "stdin: invalid gzip header\n");
                                        return 1;
                                }
                        }
                        while (ch);
                }
                if (gzheader.flg & FHCRC) {
                        len = fread(buf, 1, 2, stdin);
                        if (len < 0) {
                                perror("stdin");
                                return 1;
                        }
                        if (len != 2) {
                                fprintf(stderr, "stdin: invalid gzip header\n");

                                return 1;
                        }
                }
        }

        /* Now write the output magic number. */
        if (mkgzip) {
                if (fwrite(magic_gzip, 1, 2, stdout) != 2) {
                        perror("stdout");
                        return 1;
                }
        }
        else {
                if (fwrite(magic_strong, 1, 2, stdout) != 2) {
                        perror("stdout");
                        return 1;
                }
        }

        /* Now write the gzip header if necessary. */
        if (mkgzip) {
                gzheader.cm = CM_DEFLATE;
                gzheader.flg = 0;
                gzheader.mtime[0] = 0;
                gzheader.mtime[1] = 0;
                gzheader.mtime[2] = 0;
                gzheader.mtime[3] = 0;
                gzheader.xfl = 0;
                gzheader.os = OS_UNIX;
                if (fwrite(&gzheader, sizeof(struct gzheader), 1, stdout) != 1)
{
                        perror("stdout");
                        return 1;
                }
        }

        /* Now actually copy the data! */
        for (;;) {
                len = fread(buf, 1, sizeof(buf), stdin);
                if (len < 0) {
                        perror("stdin");
                        return 1;
                }
                if (len == 0)
                        break;
                if (fwrite(buf, 1, len, stdout) != len) {
                        perror("stdout");
                        return 1;
                }
        }

        /* I can't believe we're done! */
        return 0;
}