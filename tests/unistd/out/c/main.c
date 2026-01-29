
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

int main(void) {
	printf("unistd test\n");

	const pid_t pid = getpid();
	printf("pid = %d\n", pid);

	const long hid = gethostid();
	printf("hostid = %ld\n", hid);

	// current control terminal
	char cterm[128];
	ctermid(cterm);
	printf("ctermid = %s\n", (char*)cterm);

	// current working directory
	char cwd[128];
	getcwd(cwd, (size_t)LENGTHOF(cwd));
	printf("cwd = %s\n", (char*)cwd);

	char *const tty = ttyname(0);
	printf("ttyname = %s\n", (char*)tty);


	char *const s = getenv("PATH");
	printf("PATH = %s\n", (char*)s);

	while (true) {
		printf("- hi\n");
		sleep(1);// time in seconds
	}

	return 0;
}


