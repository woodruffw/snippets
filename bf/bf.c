/*	bf.c
	Author(s): William Woodruff, rmNULL
	------------------------
	A short brainfuck 'compiler'.
	Generates C source code for a given brainfuck file,
	which can then be compiled to produce a functioning executable.
	Follows the original brainfuck implementation, which used a
	30,000 byte stack.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define EIGHT_KB (8192)

int main(int argc, char const *argv[])
{
	if (argc != 3)
	{
		printf("Usage: %s <file.bf> <output file>\n", argv[0]);
		return EXIT_FAILURE;
	}
	else
	{
		FILE *bf_file = fopen(argv[1], "r");
		int unmatched_braces = 0;
		char c;
		size_t maxsize = EIGHT_KB;
		size_t size = 0;
		char *op_buffer = malloc(EIGHT_KB);
		if (op_buffer == NULL) {
			fputs("allocation failed, exiting now", stderr);
			exit(1);
		}

		while ((c = fgetc(bf_file)) != EOF)
		{
			if (size+14 == maxsize)
			{
				maxsize *= 2;
				op_buffer = realloc(op_buffer, maxsize);
				if (op_buffer == NULL) {
					fputs("buffer overflow exiting", stderr);
					exit(1);
				}
			}

			switch(c)
			{
				case '>':
					strncat(op_buffer, "++sp;", 5);
					size += 5;
					break;
				case '<':
					strncat(op_buffer, "--sp;", 5);
					size += 5;
					break;
				case '+':
					strncat(op_buffer, "++*sp;", 6);
					size += 6;
					break;
				case '-':
					strncat(op_buffer, "--*sp;", 6);
					size += 6;
					break;
				case '.':
					strncat(op_buffer, "-putchar(*sp);", 14);
					size += 14;
					break;
				case ',':
					strncat(op_buffer, "*sp=getchar();", 14);
					size += 14;
					break;
				case '[':
					strncat(op_buffer, "while(*sp){", 11);
					size += 11;
					++unmatched_braces;
					break;
				case ']':
					strncat(op_buffer, "}", 1);
					size += 1;
					--unmatched_braces;
					break;
				default:
					break;
			}
		}

		if (unmatched_braces)
		{
			fprintf(stderr, "Expected %s. Exiting",
				unmatched_braces < 0 ? "'[' before ']'": "']' after '['");
			free(op_buffer);
			exit(-1);
		}
		strncat(op_buffer + size-1, "}", 1);

		FILE *c_output = fopen(argv[2], "w");
		fputs("/* generated by bf.c */#include <stdio.h>\nint main(void) {char s[30000]={0};char*sp=s;", c_output);
		fputs(op_buffer, c_output);
		free(op_buffer);
		fclose(c_output);
		fclose(bf_file);

		printf("Output written to: %s.\n", argv[2]);
	}
	return EXIT_SUCCESS;
}
