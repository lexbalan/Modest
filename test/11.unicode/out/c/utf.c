
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>




// декодирует символ UTF-32 в последовательность UTF-8
void utf32_to_utf8(uint32_t c, char *buf)
{
    const uint32_t x = (const uint32_t)c;
    if (x <= 0x0000007F) {
        buf[0] = (char)x;
        buf[1] = (char)0;
    } else if (x <= 0x000007FF) {
        const uint32_t a = x >> 6 & 0x1F;
        const uint32_t b = x >> 0 & 0x3F;
        buf[0] = (char)(0xC0 | a);
        buf[1] = (char)(0x80 | b);
        buf[2] = (char)0;
    } else if (x <= 0x0000FFFF) {
        const uint32_t a = x >> 12 & 0x0F;
        const uint32_t b = x >> 6 & 0x3F;
        const uint32_t c = x >> 0 & 0x3F;
        buf[0] = (char)(0xE0 | a);
        buf[1] = (char)(0x80 | b);
        buf[2] = (char)(0x80 | c);
        buf[3] = (char)0;
    } else if (x <= 0x0010FFFF) {
        const uint32_t a = x >> 18 & 0x07;
        const uint32_t b = x >> 12 & 0x3F;
        const uint32_t c = x >> 6 & 0x3F;
        const uint32_t d = x >> 0 & 0x3F;
        buf[0] = (char)(0xF0 | a);
        buf[1] = (char)(0x80 | b);
        buf[2] = (char)(0x80 | c);
        buf[3] = (char)(0x80 | d);
        buf[4] = (char)0;
    }
}


void utf32_putchar(uint32_t c)
{
    char decoded_buf[5];
    utf32_to_utf8(c, &decoded_buf[0]);

    int32_t i = (int32_t)0;
    while (true) {
        const char c = decoded_buf[i];
        if ((uint8_t)c == 0) {break;}
        putchar((int32_t)c);
        i = i + 1;
    }
}


void utf32_puts(uint32_t *s)
{
    int32_t i = (int32_t)0;
    while (true) {
        const uint32_t c = s[i];
        if ((uint32_t)c == 0) {break;}
        utf32_putchar(c);
        i = i + 1;
    }
}


void utf16_puts(uint16_t *s)
{
    int32_t i = (int32_t)0;
    while (true) {
        const uint16_t c = s[i];
        if ((uint16_t)c == 0) {break;}
        utf32_putchar((uint32_t)c);
        i = i + 1;
    }
}


void utf8_puts(char *s)
{
    int32_t i = (int32_t)0;
    while (true) {
        const char c = s[i];
        if ((uint8_t)c == 0) {break;}
        putchar((int)c);
        i = i + 1;
    }
}

