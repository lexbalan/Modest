
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
	printf(/*4*/"unistd test\n");

	const pid_t pid = getpid();
	printf(/*4*/"pid = %d\n", pid);

	const long hid = gethostid();
	printf(/*4*/"hostid = %ld\n", hid);

	// current control terminal
	char cterm[128];
	ctermid(/*4*/&cterm[0]);
	printf(/*4*/"ctermid = %s\n", /*4*/(char*)&cterm);

	// current working directory
	char cwd[128];
	getcwd(/*4*/&cwd[0], (size_t)LENGTHOF(cwd));
	printf(/*4*/"cwd = %s\n", /*4*/(char*)&cwd);

	char *const tty = ttyname(0);
	printf(/*4*/"ttyname = %s\n", /*4*/(char*)tty);


	char *const s = getenv(/*4*/"PATH");
	printf(/*4*/"PATH = %s\n", /*4*/(char*)s);

	while (true) {
		printf(/*4*/"- hi\n");
		sleep(1);// time in seconds
	}

	return 0;
}


