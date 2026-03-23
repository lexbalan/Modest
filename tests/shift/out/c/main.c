
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef __BIG_INT128__
#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
static inline __int128 abs128(__int128 x) {return x < 0 ? -x : x;}
#endif  /* __BIG_INT128__ */

#ifndef __BIG_INT256__
#define BIG_INT256(a, b, c, d)
#endif  /* __BIG_INT256__ */

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
	x = (uint64_t)1 << 63;
	if (x != (uint64_t)0x8000000000000000LL) {
		printf("error: 1 << 63 != 0x8000000000000000\n");
		return false;
	}
	x = (uint64_t)0x8000000000000000LL >> 63;
	if (x != 0x1) {
		printf("error: 0x8000000000000000 >> 63 != 0x0000000000000001\n");
		return false;
	}
	printf("passed: Shift64 test\n");
	return true;
}

static bool testShift128(void) {
	unsigned __int128 x;
	x = (unsigned __int128)1 << 127;
	if (x != (unsigned __int128)BIG_INT128(0x8000000000000000LL, 0x0)) {
		printf("error: Word128 1 << 127 != 0x80000000000000000000000000000000\n");
		return false;
	}
	x = (unsigned __int128)BIG_INT128(0x8000000000000000LL, 0x0) >> 127;
	if (x != 0x1) {
		printf("error: Word128 0x80000000000000000000000000000000 >> 127 != 0x00000000000000000000000000000001\n");
		return false;
	}
	x = (unsigned __int128)1 << 127;
	if (x != (unsigned __int128)BIG_INT128(0x8000000000000000LL, 0x0)) {
		printf("error: 1 << 127 != 0x80000000000000000000000000000000\n");
		return false;
	}
	x = (unsigned __int128)BIG_INT128(0x8000000000000000LL, 0x0) >> 127;
	if (x != 0x1) {
		printf("error: 0x80000000000000000000000000000000 >> 127 != 0x00000000000000000000000000000001\n");
		return false;
	}
	printf("passed: Shift128 test\n");
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
	result = testShift128();
	success = success && result;
	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

