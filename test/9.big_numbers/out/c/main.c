// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"






static unsigned __int128 big0 = (((__int128)0x123456789ABCDEF << 64) | ((__int128)0xFEDCBA9876543210));

static uint64_t high_128(unsigned __int128 x)
{
	return (uint64_t)(x >> 64);
}

static uint64_t low_128(unsigned __int128 x)
{
	return (uint64_t)(x & 0xFFFFFFFFFFFFFFFF);
}

int main()
{

	#define __big1  (((__int128)0xFFFFFFFFFFFFFFFF << 64) | ((__int128)0xFFFFFFFFFFFFFFFF))

	unsigned __int128 big2;
	big2 = __big1;

	unsigned __int128 big3 = 0x1;

	uint32_t a = 0x1;

	unsigned __int128 big_sum = __big1 + big2 + (unsigned __int128)a;

	printf("big0 = 0x%llX%llX\n", high_128((unsigned __int128)big0), low_128((unsigned __int128)big0));
	printf("big1 = 0x%llX%llX\n", high_128((unsigned __int128)__big1), low_128((unsigned __int128)__big1));
	printf("big2 = 0x%llX%llX\n", high_128((unsigned __int128)big2), low_128((unsigned __int128)big2));
	printf("big3 = 0x%llX%llX\n", high_128((unsigned __int128)big3), low_128((unsigned __int128)big3));
	printf("big_sum = 0x%llX%llX\n", high_128((unsigned __int128)big_sum), low_128((unsigned __int128)big_sum));


	// signed big int test
	#define __sig0  (-1)

	__int128 sig1 = __sig0;

	sig1 = sig1 + 1;

	printf("sig1 = %lld\n", (uint64_t)sig1);

	return 0;

#undef __big1
#undef __sig0
}

