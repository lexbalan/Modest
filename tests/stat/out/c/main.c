// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define main_filename  "Makefile"
int main();




int main()
{
	printf("stat(\"%s\"):\n", (char *)main_filename);

	struct stat fileStat;
	if (stat(main_filename, (struct stat *)&fileStat) < 0) {
		printf("stat error\n");
		return 1;
	}

	printf(" device: %x\n", fileStat.st_dev);
	printf(" inode: %lld\n", fileStat.st_ino);
	printf(" UID: %u\n", fileStat.st_uid);
	printf(" GID: %u\n", fileStat.st_gid);
	printf(" rdev: %u\n", fileStat.st_rdev);
	printf(" blksize: %u\n", fileStat.st_blksize);
	printf(" blocks: %lld\n", fileStat.st_blocks);
	printf(" size: %lld bytes\n", fileStat.st_size);
	printf(" nlinks: %hu\n", fileStat.st_nlink);
	printf(" perm: %o\n", fileStat.st_mode);
	// UNIX filesystems have no creation time for files.
	// The ctime is the last time the file metadata (inode) was changed

	/*
	printf((S_ISDIR(fileStat.st_mode)) ? "d" : "-")
    printf((fileStat.st_mode & S_IRUSR) ? "r" : "-")
    printf((fileStat.st_mode & S_IWUSR) ? "w" : "-")
    printf((fileStat.st_mode & S_IXUSR) ? "x" : "-")
    printf((fileStat.st_mode & S_IRGRP) ? "r" : "-")
    printf((fileStat.st_mode & S_IWGRP) ? "w" : "-")
    printf((fileStat.st_mode & S_IXGRP) ? "x" : "-")
    printf((fileStat.st_mode & S_IROTH) ? "r" : "-")
    printf((fileStat.st_mode & S_IWOTH) ? "w" : "-")
    printf((fileStat.st_mode & S_IXOTH) ? "x" : "-")
    printf("\n")
	*/

	return 0;
}

