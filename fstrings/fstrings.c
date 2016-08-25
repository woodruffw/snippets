/*	fstrings.c
	Author: William Woodruff
	------------------------
	A "fast", naive implementation of the `strings` utility.
	Doesn't care about executable formats, has no dependencies.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BUFFERSIZE (4096)
#define REJECT(c) (((c) < 32 || (c) > 126) && ((c) != 10 || (c) != 13))

void fstrings(FILE *file, size_t min_size);

int main(int argc, char const *argv[])
{
	int size = 10;
	FILE *file = stdin;

	if (argc > 4) {
		fprintf(stderr, "%s: too many arguments\n", argv[0]);
		return 1;
	}

	for (int i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "-n"))	{
			if (i + 1 < argc) {
				size = atol(argv[++i]);

				if (size < 1) {
					fprintf(stderr, "%s: -n cannot less than 1\n", argv[0]);
					return 1;
				}
			}
			else {
				fprintf(stderr, "%s: missing argument for -n\n", argv[0]);
				return 1;
			}
		}
		else {
			file = fopen(argv[i], "r");

			if (!file) {
				fprintf(stderr, "%s: failed to open %s\n", argv[0], argv[i]);
				return 1;
			}
		}
	}

	fstrings(file, size);
	fclose(file);

	return EXIT_SUCCESS;
}

void fstrings(FILE *file, size_t min_size)
{
	char *bytes = malloc(BUFFERSIZE), *str;
	int *table = malloc(sizeof(int) * BUFFERSIZE);
	size_t bytes_size, table_index, str_size, str_index;

	while ((bytes_size = fread(bytes, 1, BUFFERSIZE, file))) {
		table_index = str_size = str_index = 0;

		for (size_t i = 0; i < bytes_size; i++) {
			if (REJECT(bytes[i])) {
				table[table_index++] = i;
			}
		}

		if (!table_index) {
			puts(bytes);
		}
		else {
			for (size_t j = 1; j < table_index; j++) {
				str_index = table[j - 1] + 1;
				str_size = table[j] - str_index;

				if (str_size >= min_size) {
					str = malloc(str_size + 1);

					memcpy(str, bytes + str_index, str_size);
					str[str_size] = '\0';
					puts(str);
					free(str);
				}
			}
		}
	}

	free(bytes);
	free(table);
}
