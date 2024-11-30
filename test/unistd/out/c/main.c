// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))











int main()
{
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
	getcwd((char *)&cwd, LENGTHOF(cwd));
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

