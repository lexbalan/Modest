
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"

#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
#define BIG_INT256(x3, x2, x1, x0)



static unsigned __int128 big0 = BIG_INT128(0x123456789ABCDEFULL, 0xFEDCBA9876543210ULL);


static uint64_t high_128(unsigned __int128 x)
{
	return x >> 64;
}


static uint64_t low_128(unsigned __int128 x)
{
	return x & 0xFFFFFFFFFFFFFFFF;
}


int main()
{

	#define __big1  BIG_INT128(0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)
	#define __big2  BIG_INT256(0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)

	unsigned __int128 big2;
	big2 = __big1;

	unsigned __int128 big3 = 0x1;

	uint32_t a = 0x1;

	unsigned __int128 big_sum = __big1 + big2 + a;

	printf("big0 = 0x%llX%llX\n", high_128(big0), low_128(big0));
	printf("big1 = 0x%llX%llX\n", high_128((unsigned __int128)__big1), low_128((unsigned __int128)__big1));
	printf("big2 = 0x%llX%llX\n", high_128(big2), low_128(big2));
	printf("big3 = 0x%llX%llX\n", high_128(big3), low_128(big3));
	printf("big_sum = 0x%llX%llX\n", high_128(big_sum), low_128(big_sum));


	// signed big int test
	#define __sig0  (-1)

	__int128 sig1 = __sig0;

	sig1 = sig1 + 1;

	printf("sig1 = %lld\n", (uint64_t)sig1);

	return 0;

#undef __big1
#undef __big2
#undef __sig0
}

