
#include <stdint.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include "./lib.h"

int32_t main() {
	printf("hello from main\n");
	lib_func();
	return 0;
}

