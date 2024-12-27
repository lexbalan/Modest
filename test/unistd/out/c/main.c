// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))
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
	ctermid(&cterm);
	printf("ctermid = %s\n", &cterm);

	// current working directory
	char cwd[128];
	getcwd(&cwd, LENGTHOF(cwd));
	printf("cwd = %s\n", &cwd);

	char(*tty)[] = ttyname(0);
	printf("ttyname = %s\n", tty);


	char * *s = getenv("PATH");
	printf("PATH = %s\n", s);

	while (true) {
		printf("- hi\n");
		sleep(1);
	}

	return 0;
}

