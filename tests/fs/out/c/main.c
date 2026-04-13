
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "sys.h"

int32_t main(void) {
	sys_init();
	const sys_Int fd = sys_open("/storage/sd/hello.txt", 0);
	if (fd < 0) {
		printf("cannot open file (error = %d)\n", fd);
		return -1;
	}
	sys_close(fd);
	return 0;
}

