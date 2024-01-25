// ./out/c/utf.c


#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




// декодирует символ UTF-32 в последовательность UTF-8
uint8_t utf32_to_utf8(uint32_t c, char *buf)
{
    const uint32_t x = (const uint32_t)c;

    if (x <= 0x0000007F) {
        buf[0] = (char)x;
        buf[1] = 0;
        return 2;

    } else if (x <= 0x000007FF) {
        const uint32_t c0 = x >> 6 & 0x1F;
        const uint32_t c1 = x >> 0 & 0x3F;
        buf[0] = (char)(0xC0 | c0);
        buf[1] = (char)(0x80 | c1);
        buf[2] = 0;
        return 3;

    } else if (x <= 0x0000FFFF) {
        const uint32_t c0 = x >> 12 & 0x0F;
        const uint32_t c1 = x >> 6 & 0x3F;
        const uint32_t c2 = x >> 0 & 0x3F;
        buf[0] = (char)(0xE0 | c0);
        buf[1] = (char)(0x80 | c1);
        buf[2] = (char)(0x80 | c2);
        buf[3] = 0;
        return 4;

    } else if (x <= 0x0010FFFF) {
        const uint32_t c0 = x >> 18 & 0x07;
        const uint32_t c1 = x >> 12 & 0x3F;
        const uint32_t c2 = x >> 6 & 0x3F;
        const uint32_t c3 = x >> 0 & 0x3F;
        buf[0] = (char)(0xF0 | c0);
        buf[1] = (char)(0x80 | c1);
        buf[2] = (char)(0x80 | c2);
        buf[3] = (char)(0x80 | c3);
        buf[4] = 0;
        return 5;
    }

    return 0;
}


// algorithm from wikipedia
// (https://ru.wikipedia.org/wiki/UTF-16)
// returns n-symbols from input stream
uint8_t utf16_to_utf32(uint16_t *c, uint32_t *result)
{
    const uint32_t leading = ((const uint32_t)(uint16_t)c[0]);

    if ((leading < 0xD800) || (leading > 0xDFFF)) {
        *result = (uint32_t)leading;
        return 1;
    } else if (leading >= 0xDC00) {
        //error("Недопустимая кодовая последовательность.")
    } else {
        uint32_t code;
        code = (leading & 0x3FF) << 10;
        const uint32_t trailing = ((const uint32_t)(uint16_t)c[1]);
        if ((trailing < 0xDC00) || (trailing > 0xDFFF)) {
            //error("Недопустимая кодовая последовательность.")
        } else {
            code = code | trailing & 0x3FF;
            *result = (uint32_t)(code + 0x10000);
            return 2;
        }
    }

    return 0;
}


void utf32_putchar(uint32_t c)
{
    char decoded_buf[5];
    const int n = (const int)utf32_to_utf8(c, (char *)&decoded_buf);

    int32_t i = 0;
    while (i < n) {
        const char c = decoded_buf[i];
        if ((uint8_t)c == 0) {break;}
        putchar((int)(int32_t)c);
        i = i + 1;
    }
}


void utf32_puts(uint32_t *s)
{
    int32_t i = 0;
    while (true) {
        const uint32_t c = s[i];
        if ((uint32_t)c == 0) {break;}
        utf32_putchar((uint32_t)c);
        i = i + 1;
    }
}


void utf16_puts(uint16_t *s)
{
    int32_t i = 0;
    while (true) {
        const uint16_t c = s[i];
        if ((uint16_t)c == 0) {break;}

        uint32_t c32;
        const uint8_t n = utf16_to_utf32((uint16_t *)&s[i], &c32);

        if (n == 0) {break;}

        utf32_putchar(c32);

        i = i + (int32_t)n;
    }
}


void utf8_puts(char *s)
{
    int32_t i = 0;
    while (true) {
        const char c = s[i];
        if ((uint8_t)c == 0) {break;}
        putchar((int)c);
        i = i + 1;
    }
}

