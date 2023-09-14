
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/hello_world/main.cm


// there's no way to use 128-bit literals
// for global variables initializers
// when used C backend ()
static unsigned __int128 big0 = 0x123456789ABCDEFL;


uint64_t high_128(unsigned __int128 x)
{
    return (uint64_t)(x >> 64);
}


uint64_t low_128(unsigned __int128 x)
{
    return (uint64_t)(x & 0xFFFFFFFFFFFFFFFFL);
}


int main(void)
{
    __int128 big1;big1 = 0xFFFFFFFFFFFFFFFF;
    big1 <<= 64;
    big1 |= 0xFFFFFFFFFFFFFFFF;

    unsigned __int128 big2;
    big2 = 0xFFFFFFFFFFFFFFFF;
    big2 <<= 64;
    big2 |= 0xFFFFFFFFFFFFFFFF;

    unsigned __int128 big3 = 0x1;

    uint32_t a = 0x1;

    unsigned __int128 big_sum = big1 + big2 + (unsigned __int128)a;

    printf("big0 = 0x%llX%llX\n", high_128(big0), low_128(big0));
    printf("big1 = 0x%llX%llX\n", high_128(big1), low_128(big1));
    printf("big2 = 0x%llX%llX\n", high_128(big2), low_128(big2));
    printf("big3 = 0x%llX%llX\n", high_128(big3), low_128(big3));
    printf("big_sum = 0x%llX%llX\n", high_128(big_sum), low_128(big_sum));

    return 0;
}

