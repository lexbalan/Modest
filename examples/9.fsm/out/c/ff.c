
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>


// for clock()

// for printf


typedef int64_t ArchInt;
typedef uint64_t ArchNat;


void ff_memzero(void *mem, uint64_t len)
{
    const uint64_t len_words = len / sizeof(ArchNat);

    ArchNat *const dst_word = (ArchNat *const)mem;

    uint64_t i = 0;
    while (i < len_words) {
        dst_word[i] = 0;
        i = i + 1;
    }


    const uint64_t len_bytes = len % sizeof(ArchNat);

    uint8_t *const dst_byte = (uint8_t *const)&dst_word[i];

    i = 0;
    while (i < len_bytes) {
        dst_byte[i] = 0;
        i = i + 1;
    }
}


void ff_memcpy(void *dst, void *src, uint64_t len)
{
    const uint64_t len_words = len / sizeof(ArchNat);

    ArchNat *const src_w = (ArchNat *const)src;
    ArchNat *const dst_w = (ArchNat *const)dst;

    uint64_t i = 0;
    while (i < len_words) {
        dst_w[i] = src_w[i];
        i = i + 1;
    }


    const uint64_t len_bytes = len % sizeof(ArchNat);

    uint8_t *const src_b = (uint8_t *const)&src_w[i];
    uint8_t *const dst_b = (uint8_t *const)&dst_w[i];

    i = 0;
    while (i < len_bytes) {
        dst_b[i] = src_b[i];
        i = i + 1;
    }
}


uint64_t ff_cstrlen(uint8_t *cstr)
{
    uint64_t i = 0;
    while (cstr[i] != '\x0') {
        i = i + 1;
    }
    return i;
}



void delay_us(uint64_t us)
{
    const uint64_t start_time = clock();

    while (clock() < start_time + us) {
        // waiting
    }
}


void delay(uint64_t us)
{
    delay_us(us);
}


void delay_ms(uint64_t ms)
{
    delay_us(ms * 1000);
}


void delay_s(uint64_t s)
{
    delay_ms(s * 1000);
}
