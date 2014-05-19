/*	battstat.c
	Author: William Woodruff
	------------------------
	Determines the status of the system's battery via sysfs.
	If no battery is installed, fails.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>

#define MAX_CHAR 32

int main(void)
{
	char status[MAX_CHAR];
	int curr_charge, full_charge;
	double percent;

	FILE* batt_file;

	if (batt_file = fopen("/sys/class/power_supply/BAT0/status", "r"))
	{
		fgets(status, MAX_CHAR, batt_file);
		fclose(batt_file);

		batt_file = fopen("/sys/class/power_supply/BAT0/charge_now", "r");
		fscanf(batt_file, "%d", &curr_charge);
		fclose(batt_file);

		batt_file = fopen("/sys/class/power_supply/BAT0/charge_full", "r");
		fscanf(batt_file, "%d", &full_charge);
		fclose(batt_file);

		percent = ((double) curr_charge / full_charge) * 100;

		printf("%s%s", "Battery status: ", status);
		printf("%s%2.1f%%\n", "Current charge: ", percent);
	}
	else
	{
		printf("%s\n", "Error: No battery detected.");
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}