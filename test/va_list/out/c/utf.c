// algorithms from wikipedia
// (https://ru.wikipedia.org/wiki/UTF-16)

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>


#include "./utf.h"


// декодирует символ UTF-32 в последовательность UTF-8
uint8_t utf32_to_utf8(uint32_t c, char *buf)
{
    const uint32_t x = (uint32_t)c;

    if (x <= 0x0000007F) {
        buf[0] = (char)x;
        return 1;

    } else if (x <= 0x000007FF) {
        const uint32_t c0 = x >> 6 & 0x1F;
        const uint32_t c1 = x >> 0 & 0x3F;
        buf[0] = (char)(0xC0 | c0);
        buf[1] = (char)(0x80 | c1);
        return 2;

    } else if (x <= 0x0000FFFF) {
        const uint32_t c0 = x >> 12 & 0x0F;
        const uint32_t c1 = x >> 6 & 0x3F;
        const uint32_t c2 = x >> 0 & 0x3F;
        buf[0] = (char)(0xE0 | c0);
        buf[1] = (char)(0x80 | c1);
        buf[2] = (char)(0x80 | c2);
        return 3;

    } else if (x <= 0x0010FFFF) {
        const uint32_t c0 = x >> 18 & 0x07;
        const uint32_t c1 = x >> 12 & 0x3F;
        const uint32_t c2 = x >> 6 & 0x3F;
        const uint32_t c3 = x >> 0 & 0x3F;
        buf[0] = (char)(0xF0 | c0);
        buf[1] = (char)(0x80 | c1);
        buf[2] = (char)(0x80 | c2);
        buf[3] = (char)(0x80 | c3);
        return 4;
    }

    return 0;
}


// returns n-symbols from input stream
uint8_t utf16_to_utf32(uint16_t *c, uint32_t *result)
{
    const uint32_t leading = (uint32_t)c[0];

    if ((leading < 0xD800) || (leading > 0xDFFF)) {
        *result = (uint32_t)leading;
        return 1;
    } else if (leading >= 0xDC00) {
        //error("Недопустимая кодовая последовательность.")
    } else {
        uint32_t code;
        code = (leading & 0x3FF) << 10;
        const uint32_t trailing = (uint32_t)c[1];
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


//
// putchar
//


void utf8_putchar(char c)
{
    putchar((int)(int32_t)c);
}


void utf16_putchar(uint16_t c)
{
    uint16_t cc[2];
    cc[0] = c;
    cc[1] = 0;
    uint32_t char32;
    const uint8_t n = utf16_to_utf32((uint16_t *)(uint16_t *)&cc, &char32);
    utf32_putchar(char32);
}


void utf32_putchar(uint32_t c)
{
    char decoded_buf[4];
    const int n = (int)utf32_to_utf8(c, (char *)&decoded_buf);

    int32_t i;
    i = 0;
    while (i < n) {
        const char c = decoded_buf[i];
        utf8_putchar(c);
        i = i + 1;
    }
}


//
// puts
//

void utf8_puts(char *s)
{
    int32_t i;
    i = 0;
    while (true) {
        const char c = s[i];
        if (c == 0) {break;}
        utf8_putchar(c);
        i = i + 1;
    }
}


void utf16_puts(uint16_t *s)
{
    int32_t i;
    i = 0;
    while (true) {
        // нельзя просто так взять и вызвать utf16_putchar
        // тк в строке может быть суррогатная пара UTF_16 символов

        const uint16_t cc16 = s[i];
        if (cc16 == 0) {break;}

        uint32_t char32;
        const uint8_t n = utf16_to_utf32((uint16_t *)&s[i], &char32);
        if (n == 0) {break;}

        utf32_putchar(char32);

        i = i + (int32_t)n;
    }
}


void utf32_puts(uint32_t *s)
{
    int32_t i;
    i = 0;
    while (true) {
        const uint32_t c = s[i];
        if (c == 0) {break;}
        utf32_putchar(c);
        i = i + 1;
    }
}

