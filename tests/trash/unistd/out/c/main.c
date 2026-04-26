
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
// getenv

int main(void) {
	printf("unistd test\n");
	const pid_t main_pid = getpid();
	printf("pid = %d\n", main_pid);
	const long main_hid = gethostid();
	printf("hostid = %ld\n", main_hid);
	char cterm[128];
	ctermid(cterm);
	printf("ctermid = %s\n", cterm);
	char cwd[128];
	getcwd(cwd, (size_t)LENGTHOF(cwd));
	printf("cwd = %s\n", cwd);
	char *const main_tty = ttyname(0);
	printf("ttyname = %s\n", main_tty);
	char *const main_s = getenv("PATH");
	printf("PATH = %s\n", main_s);
	while (true) {
		printf("- hi\n");
		sleep(1U);
	}
	return 0;
}

