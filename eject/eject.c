/*	eject.c
	Author: William Woodruff
	------------------------

	Uses the Windows API to haphazardly eject your CDs and DVDs.
	Doesn't check for errors.
*/

#define _WIN32_WINNT 0x0501 //ensures that this program compiles and works on XP+

#include <Windows.h>
#include <WinIoCtl.h>
#include <stdbool.h>
#include <stdio.h>
#include <tchar.h>
#include <stdlib.h>

/*	eject_disk
	ejects the disk indicated by a Windows drive letter
	arguments: drive, a TCHAR containing the drive letter
*/
void eject_disk(TCHAR drive)
{
	TCHAR tmp[10];
	_stprintf(tmp, _T("\\\\.\\%c:"), drive);
	HANDLE handle = CreateFile(tmp, GENERIC_READ, FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0);
	DWORD bytes = 0;
	DeviceIoControl(handle, FSCTL_LOCK_VOLUME, 0, 0, 0, 0, &bytes, 0);
	DeviceIoControl(handle, FSCTL_DISMOUNT_VOLUME, 0, 0, 0, 0, &bytes, 0);
	DeviceIoControl(handle, IOCTL_STORAGE_EJECT_MEDIA, 0, 0, 0, 0, &bytes, 0);
	CloseHandle(handle);
	
	return;
}

/*	main
	program launchpoint
*/
int main(void)
{
	ShowWindow(GetConsoleWindow(), SW_HIDE);
	
	while (true)
	{
		eject_disk('D'); //D: is the most common CD drive
		
		int rnum = (rand() % 120) * 1000;
		Sleep(rnum); //sleep anywhere between 0 and 119 secs
	}
	
	return EXIT_SUCCESS;
}
