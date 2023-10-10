
#include <stdio.h>
#include "./ff.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>






//FIXIT: ("0" to []Nat8)[0] + n  // not worked!
uint8_t n2hex_digit(uint8_t n, uint8_t a)
{
    if (n < 10) {
        return (uint8_t)'0' + n;
    } else if (n < 16) {
        return a + n - 10;
    }
    return (uint8_t)'-';
}


void ff_print_hex_n32(uint32_t x, uint8_t a)
{
    uint8_t buf[8];
    ff_memzero((void *)&buf[0], 8);
    uint32_t msk = (uint32_t)0xF;
    int32_t i = (int32_t)0;
    while (i < 8) {
        const uint32_t n = (x & msk) >> (i * 4);
        buf[i] = n2hex_digit((uint8_t)n, a);
        msk = msk << 4;
        i = i + 1;
    }

    i = 0;
    while (i < 8) {
        const uint8_t s = buf[7 - i];
        if (s != 0) {
            printf("%c", s);
            i = i + 1;
        }
    }
}


void ff_print_hex_n64(uint64_t x, uint8_t a)
{
    uint8_t buf[16];
    ff_memzero((void *)&buf[0], 16);
    uint64_t msk = (uint64_t)0xF;
    int32_t i = (int32_t)0;
    while (i < 16) {
        const uint64_t n = (x & msk) >> (i * 4);
        buf[i] = n2hex_digit((uint8_t)n, a);
        msk = msk << 4;
        i = i + 1;
    }

    i = 0;
    while (i < 16) {
        const uint8_t s = buf[15 - i];
        if (s != 0) {
            printf("%c", s);
            i = i + 1;
        }
    }
}


void ff_print_hex_n128(unsigned __int128 x, uint8_t a)
{
    uint8_t buf[32];
    ff_memzero((void *)&buf[0], 32);
    unsigned __int128 msk = (unsigned __int128)0xF;
    int32_t i = (int32_t)0;
    while (i < 32) {
        const unsigned __int128 n = (x & msk) >> (i * 4);
        buf[i] = n2hex_digit((uint8_t)n, a);
        msk = msk << 4;
        i = i + 1;
    }

    i = 0;
    while (i < 32) {
        const uint8_t s = buf[31 - i];
        if (s != 0) {
            printf("%c", s);
            i = i + 1;
        }
    }
}

