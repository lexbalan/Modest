// tests/unistd/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */
  // getenv

int main() {
	printf("unistd test\n");

	const pid_t pid = getpid();
	printf("pid = %d\n", pid);

	const long hid = gethostid();
	printf("hostid = %ld\n", hid);

	// current control terminal
	char cterm[128];
	ctermid((char *)&cterm);
	printf("ctermid = %s\n", (char *)&cterm);

	// current working directory
	char cwd[128];
	getcwd((char *)&cwd, (size_t)LENGTHOF(cwd));
	printf("cwd = %s\n", (char *)&cwd);

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


