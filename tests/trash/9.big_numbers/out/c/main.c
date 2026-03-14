
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
static unsigned __int128 big0 = 0x123456789ABCDEFFEDCBA9876543210XL;

static uint64_t high_128(unsigned __int128 x) {
	return /*$*/((uint64_t)(x >> 64));
}

static uint64_t low_128(unsigned __int128 x) {
	return /*$*/((uint64_t)(x & 0xFFFFFFFFFFFFFFFFLL));
}

int main(void) {
	#define big1 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFXL
	#define big2 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFXL
	unsigned __int128 big3 = 0x1;
	uint32_t a = 1;
	unsigned __int128 big_sum = big1 + big2 + /*$*/((unsigned __int128)a);
	printf("big0 = 0x%llX%llX\n", high_128(big0), low_128(big0));
	printf("big1 = 0x%llX%llX\n", high_128(big1), low_128(big1));
	printf("big3 = 0x%llX%llX\n", high_128(big3), low_128(big3));
	printf("big_sum = 0x%llX%llX\n", high_128(big_sum), low_128(big_sum));
	const int8_t sig0 = -1;
	__int128 sig1 = sig0;
	sig1 = sig1 + 1;
	printf("sig1 = %lld\n", (uint64_t)llabs(sig1));
	return 0;
}
