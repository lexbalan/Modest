
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


static bool testShift8(void) {
	uint8_t x;
	x = 0x1 << 7;
	if (x != 0x80) {
		printf("error: Word8 1 << 7 != 0x80\n");
		return false;
	}
	x = 0x80 >> 7;
	if (x != 0x1) {
		printf("error: Word8 0x80 >> 7 != 1\n");
		return false;
	}
	x = 1 << 7;
	if (x != 0x80) {
		printf("error: 1 << 7 != 0x80\n");
		return false;
	}
	x = 128 >> 7;
	if (x != 0x1) {
		printf("error: 0x80 >> 7 != 1\n");
		return false;
	}
	printf("passed: Shift8 test\n");
	return true;
}

static bool testShift16(void) {
	uint16_t x;
	x = 0x1 << 15;
	if (x != 0x8000) {
		printf("error: Word16 1 << 15 != 0x8000\n");
		return false;
	}
	x = 0x8000 >> 15;
	if (x != 0x1) {
		printf("error: Word16 0x8000 >> 15 != 1\n");
		return false;
	}
	x = 1 << 15;
	if (x != 0x8000) {
		printf("error: 1 << 15 != 0x8000\n");
		return false;
	}
	x = 32768 >> 15;
	if (x != 0x1) {
		printf("error: 0x8000 >> 15 != 1\n");
		return false;
	}
	printf("passed: Shift16 test\n");
	return true;
}

static bool testShift32(void) {
	uint32_t x;
	x = 0x1U << 31;
	if (x != 0x80000000U) {
		printf("error: Word32 1 << 31 != 0x80000000\n");
		return false;
	}
	x = 0x80000000U >> 31;
	if (x != 0x1U) {
		printf("error: Word32 0x80000000 >> 31 != 1\n");
		return false;
	}
	x = 1 << 31;
	if (x != 0x80000000U) {
		printf("error: 1 << 31 != 0x80000000\n");
		return false;
	}
	x = 2147483648U >> 31;
	if (x != 0x1U) {
		printf("error: 0x80000000 >> 31 != 1\n");
		return false;
	}
	printf("passed: Shift32 test\n");
	return true;
}

static bool testShift64(void) {
	uint64_t x;
	x = 0x1ULL << 63;
	if (x != 0x8000000000000000ULL) {
		printf("error: Word64 1 << 63 != 0x8000000000000000\n");
		return false;
	}
	x = 0x8000000000000000ULL >> 63;
	if (x != 0x1ULL) {
		printf("error: Word64 0x8000000000000000 >> 63 != 1\n");
		return false;
	}
	x = (uint64_t)1 << 63;
	if (x != 0x8000000000000000ULL) {
		printf("error: 1 << 63 != 0x8000000000000000\n");
		return false;
	}
	x = 9223372036854775808ULL >> 63;
	if (x != 0x1ULL) {
		printf("error: 0x8000000000000000 >> 63 != 1\n");
		return false;
	}
	printf("passed: Shift64 test\n");
	return true;
}

static bool testShift128(void) {
	unsigned __int128 x;
	x = BIG_INT128(0x0ULL, 0x1ULL) << 127;
	if (x != BIG_INT128(0x8000000000000000ULL, 0x0ULL)) {
		printf("error: Word128 1 << 127 != 0x80000000000000000000000000000000\n");
		return false;
	}
	x = BIG_INT128(0x8000000000000000ULL, 0x0ULL) >> 127;
	if (x != BIG_INT128(0x0ULL, 0x1ULL)) {
		printf("error: Word128 0x80000000000000000000000000000000 >> 127 != 1\n");
		return false;
	}
	x = (unsigned __int128)1 << 127;
	if (x != BIG_INT128(0x8000000000000000ULL, 0x0ULL)) {
		printf("error: 1 << 127 != 0x80000000000000000000000000000000\n");
		return false;
	}
	x = BIG_INT128(0x8000000000000000ULL, 0x0ULL) >> 127;
	if (x != BIG_INT128(0x0ULL, 0x1ULL)) {
		printf("error: 0x80000000000000000000000000000000 >> 127 != 1\n");
		return false;
	}
	printf("passed: Shift128 test\n");
	return true;
}

int main(void) {
	printf("test shift\n");
	bool result = true;
	result = testShift8() && result;
	result = testShift16() && result;
	result = testShift32() && result;
	result = testShift64() && result;
	result = testShift128() && result;
	printf("test ");
	if (!result) {
		printf("failed\n");
		return EXIT_FAILURE;
	}
	printf("passed\n");
	return EXIT_SUCCESS;
}

