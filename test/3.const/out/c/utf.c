
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>




// декодирует символ UTF-32 в последовательность UTF-8
void utf32_to_utf8(uint32_t x, uint8_t *buf)
{
    if (x <= 0x0000007F) {
        buf[0] = (uint8_t)x;
        buf[1] = 0;
    } else if (x <= 0x000007FF) {
        const uint32_t a = x >> 6 & 0x1F;
        const uint32_t b = x >> 0 & 0x3F;
        buf[0] = 0xC0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0;
    } else if (x <= 0x0000FFFF) {
        const uint32_t a = x >> 12 & 0x0F;
        const uint32_t b = x >> 6 & 0x3F;
        const uint32_t c = x >> 0 & 0x3F;
        buf[0] = 0xE0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0x80 | (uint8_t)c;
        buf[3] = 0;
    } else if (x <= 0x0010FFFF) {
        const uint32_t a = x >> 18 & 0x07;
        const uint32_t b = x >> 12 & 0x3F;
        const uint32_t c = x >> 6 & 0x3F;
        const uint32_t d = x >> 0 & 0x3F;
        buf[0] = 0xF0 | (uint8_t)a;
        buf[1] = 0x80 | (uint8_t)b;
        buf[2] = 0x80 | (uint8_t)c;
        buf[3] = 0x80 | (uint8_t)d;
        buf[4] = 0;
    }
}


void utf32_putchar(uint32_t c)
{
    uint8_t decoded_buf[5];
    utf32_to_utf8(c, &decoded_buf[0]);

    int32_t i = 0;
    while (true) {
        const uint8_t c = decoded_buf[i];
        if (c == 0) {break;}
        putchar((int32_t)c);
        i = i + 1;
    }
}


void utf32_puts(uint32_t *s)
{
    int32_t i = 0;
    while (true) {
        const uint32_t c = s[i];
        if (c == 0) {break;}
        utf32_putchar(c);
        i = i + 1;
    }
}


void utf16_puts(uint16_t *s)
{
    int32_t i = 0;
    while (true) {
        const uint16_t c = s[i];
        if (c == 0) {break;}
        utf32_putchar((uint32_t)c);
        i = i + 1;
    }
}


void utf8_puts(uint8_t *s)
{
    int32_t i = 0;
    while (true) {
        const uint8_t c = s[i];
        if (c == 0) {break;}
        putchar((int)c);
        i = i + 1;
    }
}

