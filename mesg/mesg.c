/*	mesg.c
	Author: William Woodruff
	------------------------
	A quick and dirty messagebox program for Windows.
	(Partially) replaces msg.exe and "net send," which are conspicuously missing from modern versions of Windows.
	Can be called with two args or just one, in which case the "Message" header will automatically be used.
	------------------------
	Note: Compiled successfully with MinGW GCC v.4.7.2 x86. 
	Even though it is normal C, it probably won't compile in MSVC.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <Windows.h>
#include <stdio.h>

int main(int argc, char** argv)
{
	if (argc == 3)
	{
		MessageBox(NULL, argv[1], argv[2], MB_OK);
	}
	else if (argc == 2)
	{
		MessageBox(NULL, argv[1], "Message", MB_OK);
	}
	else
	{
		printf("%s\n", "Usage: mesg <message> [title]");
	}
	
	return EXIT_SUCCESS;
}

