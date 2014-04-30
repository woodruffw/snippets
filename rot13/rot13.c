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
	char instr[1024];
	fgets(instr, 1024, stdin);

	for (int i = 0; instr[i]; i++)
	{
		if (isalpha(instr[i]))
		{
			if ((instr[i] >= 65 && instr[i] <= 77) || (instr[i] >= 97 && instr[i] <= 109))
				instr[i] += 13;
			else
				instr[i] -= 13;
		}
	}

	printf("%s", instr);

	return EXIT_SUCCESS;
}
