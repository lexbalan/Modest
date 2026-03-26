
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef __BIG_INT128__
#define BIG_INT128(hi64, lo64) (((unsigned __int128)(hi64) << 64) | ((unsigned __int128)(lo64)))
__attribute__((unused)) static inline __int128 abs128(__int128 x) {return x < 0 ? -x : x;}
#endif  /* __BIG_INT128__ */


static bool test1(void) {
	if ((int64_t)4294967295U + (int64_t)1 != 4294967296LL) {
		printf("error: 0xffffffff + 1 != 0x100000000\n");
		return false;
	}
	if ((__int128_t)18446744073709551615ULL + (__int128_t)1 != BIG_INT128(0x1LL, 0x0LL)) {
		printf("error: 0xffffffffffffffff + 1 != 0x10000000000000000\n");
		return false;
	}
	#define x32 4294967295U
	if ((int64_t)x32 + (int64_t)1 != 4294967296LL) {
		printf("error: x32 + 1 != 0x100000000\n");
		return false;
	}
	#define x64 18446744073709551615ULL
	if ((__int128_t)x64 + (__int128_t)1 != BIG_INT128(0x1LL, 0x0LL)) {
		printf("error: x64 + 1 != 0x10000000000000000\n");
		return false;
	}
	printf("passed: test1\n");
	return true;
	#undef x32
	#undef x64
}

int main(void) {
	printf("test literals\n");
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

