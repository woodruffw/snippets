/*	cond.c
	Author: William Woodruff
	------------------------
	A dumb conditional checker.
	Prompts the user for a Y/N response, and returns a SUCCESS/FAIL status based on it.
	Example usage (sh): if cond "Complete?" ; then do_something ; fi
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
	if (argv[1])
	{
		printf("%s (y/N) ", argv[1]);
	}
	else
	{
		printf("Continue? (y/N) ");
	}
	char ans = getchar();
	if (ans == 'y' || ans == 'Y')
	{
		return EXIT_SUCCESS;
	}
	else
	{
		return EXIT_FAILURE;
	}
	return 0;
}