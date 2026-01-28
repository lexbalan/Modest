
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __BIG_INT128__
#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
static inline __int128 abs128(__int128 x) {
	return x < 0 ? -x : x;
}
#endif  /* __BIG_INT128__ */

#ifndef __BIG_INT256__
#define BIG_INT256(a, b, c, d)
#endif  /* __BIG_INT256__ */

#include <stdlib.h>


static unsigned __int128 big0 = BIG_INT128(0x123456789ABCDEFULL, 0xFEDCBA9876543210ULL);

static uint64_t high_128(unsigned __int128 x) {
	return (uint64_t)(x >> 64);
}


static uint64_t low_128(unsigned __int128 x) {
	return (uint64_t)(x & BIG_INT128(0x0ULL, 0xFFFFFFFFFFFFFFFFULL));
}


int main(void) {

	#define big1  BIG_INT128(0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)
	#define big2  BIG_INT256(0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)

	unsigned __int128 big3 = BIG_INT128(0x0ULL, 0x1ULL);

	uint32_t a = 1;

	unsigned __int128 big_sum = big1 + big2 + (unsigned __int128)a;

	printf(/*4*/"big0 = 0x%llX%llX\n", high_128(big0), low_128(big0));
	printf(/*4*/"big1 = 0x%llX%llX\n", high_128(big1), low_128(big1));
	//printf("big2 = 0x%llX%llX\n", high_128(big2), low_128(big2))
	printf(/*4*/"big3 = 0x%llX%llX\n", high_128(big3), low_128(big3));
	printf(/*4*/"big_sum = 0x%llX%llX\n", high_128(big_sum), low_128(big_sum));


	// signed big int test
	#define sig0  (-1)

	__int128 sig1 = sig0;

	sig1 = sig1 + BIG_INT128(0x0ULL, 0x1ULL);

	printf(/*4*/"sig1 = %lld\n", (uint64_t)abs128(sig1));

	return 0;

#undef big1
#undef big2
#undef sig0
}


