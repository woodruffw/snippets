/*	perm.c
	Author: William Woodruff
	------------------------
	Stats the given file, outputting its permissions.
	Formats: string ('rwxrwxrwx') and number (777).
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>

void print_perm_string(struct stat file_stat);
void print_perm_number(struct stat file_stat);

int main(int argc, char** argv)
{
	if (argc != 3 || (argv[1][1] != 's' && argv[1][1] != 'n'))
	{
		printf("%s\n", "Usage: perm <-s|-n <file>>");
		return EXIT_FAILURE;
	}

	struct stat file_stat;
	if (stat(argv[2], &file_stat) < 0)
	{
		printf("%s%s\n", "Error stating given file: ", argv[2]);
		return EXIT_FAILURE;
	}

	if (argv[1][1] == 's')
	{
		print_perm_string(file_stat);
	}
	else if (argv[1][1] == 'n')
	{
		print_perm_number(file_stat);
	}

	return EXIT_SUCCESS;
}

/*	print_perm_string
	prints a permission string based upon the mode stored in file_stat
	format: "rwxrwxrwx"
*/
void print_perm_string(struct stat file_stat)
{
	char perm_string[10] = "---------";
	mode_t mode = file_stat.st_mode;

	(mode & S_IRUSR) ? (perm_string[0] = 'r') : (perm_string[0] = '-');
	(mode & S_IWUSR) ? (perm_string[1] = 'w') : (perm_string[1] = '-');
	(mode & S_IXUSR) ? (perm_string[2] = 'x') : (perm_string[2] = '-');
	(mode & S_IRGRP) ? (perm_string[3] = 'r') : (perm_string[3] = '-');
	(mode & S_IWGRP) ? (perm_string[4] = 'w') : (perm_string[4] = '-');
	(mode & S_IXGRP) ? (perm_string[5] = 'x') : (perm_string[5] = '-');
	(mode & S_IROTH) ? (perm_string[6] = 'r') : (perm_string[6] = '-');
	(mode & S_IWOTH) ? (perm_string[7] = 'w') : (perm_string[7] = '-');
	(mode & S_IXOTH) ? (perm_string[8] = 'x') : (perm_string[8] = '-');

	printf("%s\n", perm_string);
}

/*	print_perm_number
	prints a permission number based upon the mode stored in file_stat
	format: "777"
*/
void print_perm_number(struct stat file_stat)
{
	int user = 0, group = 0, others = 0;
	mode_t mode = file_stat.st_mode;

	if (mode & S_IRUSR) (user += 4);
	if (mode & S_IWUSR) (user += 2);
	if (mode & S_IXUSR) (user += 1);
	if (mode & S_IRGRP) (group += 4);
	if (mode & S_IWGRP) (group += 2);
	if (mode & S_IXGRP) (group += 1);
	if (mode & S_IROTH) (others += 4);
	if (mode & S_IWOTH) (others += 2);
	if (mode & S_IXOTH) (others += 1);

	printf("%d%d%d\n", user, group, others);
}