// ./out/c/putchar.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "./utf.h"



void putchar8(char c)
{
    utf8_putchar(c);
}


void putchar16(uint16_t c)
{
    utf16_putchar(c);
}


void putchar32(uint32_t c)
{
    utf32_putchar(c);
}

