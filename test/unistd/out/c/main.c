// test/unistd/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <time.h>
#include <unistd.h>
/* forward type declaration */
/* anon recs */




//import "libc/libc" // getenv

char *getenv(char *name);

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
	getcwd((char *)&cwd, (sizeof(cwd) / sizeof(cwd[0])));
	printf("cwd = %s\n", (char *)&cwd);

	char *const tty = ttyname(0);
	printf("ttyname = %s\n", tty);


	char *const s = getenv("PATH");
	printf("s = %s\n", s);

	while (true) {
		printf("- hi\n");
		sleep(1);
	}

	return 0;
}

