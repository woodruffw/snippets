/*	mntinfo.c
	Author: William Woodruff
	------------------------
	Gets information about the given filesystem from /etc/mtab and statvfs.
	The output is intended to be easily parseable with grep + awk.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <mntent.h>
#include <sys/statvfs.h>

int mntinfo(char *fs_name);
void print_mntinfo(struct mntent *ent, struct statvfs stats);

int main(int argc, char **argv)
{
	if (argc != 2) {
		printf("Usage: %s <fs name>\n", argv[0]);
		return 1;
	}

	return mntinfo(argv[1]);
}

int mntinfo(char *fs_name)
{
	FILE *mtab;
	struct mntent *ent;
	struct statvfs stats;
	bool found = false;

	mtab = setmntent("/etc/mtab", "r");

	if (!mtab) {
		fprintf(stderr, "Fatal: Could not read /etc/mtab.\n");
		return 1;
	}

	while (!found && (ent = getmntent(mtab))) {
		if (!strcmp(fs_name, ent->mnt_fsname)) {
			found = true;
		}
	}

	if (!found) {
		fprintf(stderr, "Fatal: No entry for %s in /etc/mtab.\n", fs_name);
		return 1;
	}

	if (statvfs(ent->mnt_dir, &stats) < 0) {
		fprintf(stderr, "Fatal: Could not stat %s (%s).\n", ent->mnt_dir,
			ent->mnt_fsname);
		return 1;
	}

	print_mntinfo(ent, stats);

	endmntent(mtab);

	return 0;
}

void print_mntinfo(struct mntent *ent, struct statvfs stats)
{
	/* fields from mntent struct */
	printf("mnt_fsname: %s\n", ent->mnt_fsname);
	printf("mnt_dir: %s\n", ent->mnt_dir);
	printf("mnt_type: %s\n", ent->mnt_type);
	printf("mnt_opts: %s\n", ent->mnt_opts);
	printf("mnt_freq: %d\n", ent->mnt_freq);
	printf("mnt_passno: %d\n", ent->mnt_passno);

	/* fields from statvfs struct */
	printf("f_bsize: %lu\n", stats.f_bsize);
	printf("f_frsize: %lu\n", stats.f_frsize);
	printf("f_blocks: %lu\n", stats.f_blocks);
	printf("f_bfree: %lu\n", stats.f_bfree);
	printf("f_bavail: %lu\n", stats.f_bavail);
	printf("f_files: %lu\n", stats.f_files);
	printf("f_ffree: %lu\n", stats.f_ffree);
	printf("f_favail: %lu\n", stats.f_favail);
	printf("f_fsid: %lu\n", stats.f_fsid);
	printf("f_flag: %lu\n", stats.f_flag);
	printf("f_namemax: %lu\n", stats.f_namemax);
}
