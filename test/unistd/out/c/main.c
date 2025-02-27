
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */

// getenv

int main()
{
	printf("unistd test\n");

	const pid_t pid = getpid();
	printf("pid = %d\n", pid);

	const long hid = gethostid();
	printf("hostid = %ld\n", hid);

	// current control terminal
	char cterm[128];
	memset(&cterm, 0, sizeof cterm);
	ctermid((char *)&cterm);
	printf("ctermid = %s\n", &cterm);

	// current working directory
	char cwd[128];
	memset(&cwd, 0, sizeof cwd);
	getcwd((char *)&cwd, __lengthof(cwd));
	printf("cwd = %s\n", &cwd);

	char *const tty = ttyname(0);
	printf("ttyname = %s\n", tty);


	char *const s = getenv("PATH");
	printf("PATH = %s\n", s);

	while (true) {
		printf("- hi\n");
		sleep(1);
	}

	return 0;
}

