
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include "fcntl.h"
#include "sys.h"

int32_t main(void) {
	char buf1[32];
	char buf2[32];
	sys_init();
	int rc;
	rc = sys_mkdir("/A/p");
	if (rc != 0) {
		printf("cannot create directory %d\n", rc);
	}
	const sys_Int fd = sys_open("/A/hello.txt", O_RDWR);
	if (fd < 0) {
		printf("cannot open file (error = %d)\n", fd);
		return -1;
	}
	__builtin_memcpy(&buf1, &"Hello World!", sizeof(char [32]));
	sys_write(fd, (uint8_t *)(uint8_t (*)[])buf1, 32LL);
	sys_lseek(fd, 0LL, SEEK_SET);
	sys_read(fd, (uint8_t *)(uint8_t (*)[])buf2, 32LL);
	printf("buf2 = \"%s\"\n", buf2);
	sys_close(fd);
	sys_deinit();
	return 0;
}

