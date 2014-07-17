/*	rot13.c
	Author: William Woodruff
	------------------------
	Implements the ROT13 Caesarian Cipher.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

int main(void)
{
	char buf[1024];

	do
	{
		for (int i = 0; buf[i]; i++)
		{
			if (isalpha(buf[i]))
			{
				if ((buf[i] >= 65 && buf[i] <= 77) || (buf[i] >= 97 && buf[i] <= 109))
					buf[i] += 13;
				else
					buf[i] -= 13;
			}
		}

		printf("%s", buf);
	} while (fgets(buf, 1024, stdin));

	return EXIT_SUCCESS;
}
