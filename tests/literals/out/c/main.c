
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static bool test1(void) {
	if ((int64_t)4294967295U + (int64_t)1 != 4294967296LL) {
		printf("error: 0xffffffff + 1 != 0x100000000\n");
		return false;
	}
	#define a 4294967295U
	if ((int64_t)a + (int64_t)1 != 4294967296LL) {
		printf("error: a + 1 != 0x100000000\n");
		return false;
	}
	printf("passed: test1 test\n");
	return true;
	#undef a
}

int main(void) {
	printf("test shift\n");
	bool result;
	bool success = true;
	result = test1();
	success = success && result;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

