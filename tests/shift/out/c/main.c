
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static bool testShift32(void) {
	uint32_t x;
	x = (uint32_t)1 << 31;
	if (x != 0x80000000L) {
		printf("error: Word32 1 << 31 != 0x80000000\n");
		return false;
	}
	x = (uint32_t)0x80000000L >> 31;
	if (x != 0x1) {
		printf("error: Word32 0x80000000 >> 31 != 0x00000001\n");
		return false;
	}
	x = 1 << 31;
	if (x != 0x80000000L) {
		printf("error: 1 << 31 != 0x80000000\n");
		return false;
	}
	x = 0x80000000L >> 31;
	if (x != 0x1) {
		printf("error: 0x80000000 >> 31 != 0x00000001\n");
		return false;
	}
	printf("passed: Shift32 test\n");
	return true;
}

static bool testShift64(void) {
	uint64_t x;
	x = (uint64_t)1 << 63;
	if (x != (uint64_t)0x8000000000000000LL) {
		printf("error: Word64 1 << 63 != 0x8000000000000000\n");
		return false;
	}
	x = (uint64_t)0x8000000000000000LL >> 63;
	if (x != 0x1) {
		printf("error: Word64 0x8000000000000000 >> 63 != 0x0000000000000001\n");
		return false;
	}
	x = 1 << 63;
	if (x != (uint64_t)0x8000000000000000LL) {
		printf("error: Word64 1 << 63 != 0x8000000000000000\n");
		return false;
	}
	x = (uint64_t)(0x8000000000000000LL >> 63);
	if (x != 0x1) {
		printf("error: Word64 0x8000000000000000 >> 63 != 0x0000000000000001\n");
		return false;
	}
	printf("passed: Shift64 test\n");
	return true;
}

int main(void) {
	printf("test shift\n");
	bool result;
	bool success = true;
	result = testShift32();
	success = success && result;
	result = testShift64();
	success = success && result;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

