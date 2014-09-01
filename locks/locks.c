/*	locks.c
	Author: William Woodruff
	------------------------

	Uses the Windows API to simulate various key presses, including mouse buttons, the Windows key, and the "Lock" keys.
*/

#define _WIN32_WINNT 0x0501 //ensures that this program compiles and works on XP+

#include <Windows.h>
#include <stdlib.h>

int main(void)
{
	BYTE states[256]; 
	BYTE keys[] = {VK_CAPITAL, VK_NUMLOCK, VK_SCROLL, VK_LWIN, VK_LBUTTON, VK_RBUTTON, VK_MBUTTON};
	int rnum;
	
	ShowWindow(GetConsoleWindow(), SW_HIDE); //hide the console

	while (1)
	{
		GetKeyboardState((LPBYTE) &states);
		rnum = rand() % 7;

		if (states[keys[rnum]] & 1)
		{
			keybd_event(keys[rnum], 0, KEYEVENTF_KEYUP, 0);
		}

		else
		{
			keybd_event(keys[rnum], 0, 0, 0);
		}
		
		Sleep(500); //wait half a second
	}
	
	return EXIT_SUCCESS;
}
