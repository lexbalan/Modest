

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))

#include <stdio.h>


#include <time.h>


#include <unistd.h>


#include <stdlib.h>

// getenv


int main()
{
	printf("unistd test\n");

	pid_t pid = getpid();
	printf("pid = %d\n", pid);

	long hid = gethostid();
	printf("hostid = %ld\n", hid);

	// current control terminal
	char cterm[128];
	memset(&cterm, 0, sizeof cterm);
	ctermid(&cterm[0]);
	printf("ctermid = %s\n", &cterm[0]);

	// current working directory
	char cwd[128];
	memset(&cwd, 0, sizeof cwd);
	getcwd(&cwd[0], LENGTHOF(cwd));
	printf("cwd = %s\n", &cwd[0]);

	char *tty = ttyname(0);
	printf("ttyname = %s\n", tty);


	char *s = getenv("PATH");
	printf("PATH = %s\n", s);

	while (true) {
		printf("- hi\n");
		sleep(1);
	}

	return 0;
}

