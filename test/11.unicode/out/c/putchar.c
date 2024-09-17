// ./out/c/putchar.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "putchar.h"








void putchar_putchar8(char c)
{
	putchar_utf8_putchar(c);
}

void putchar_putchar16(uint16_t c)
{
	putchar_utf16_putchar(c);
}

void putchar_putchar32(uint32_t c)
{
	putchar_utf32_putchar(c);
}

void putchar_utf8_putchar(char c)
{
	putchar((int)(int32_t)c);
}

void putchar_utf16_putchar(uint16_t c)
{
	uint16_t cc[2];
	cc[0] = c;
	cc[1] = 0;
	uint32_t char32;
	const uint8_t n = utf_utf16_to_utf32((uint16_t *)&cc, &char32);
	putchar_utf32_putchar(char32);
}

void putchar_utf32_putchar(uint32_t c)
{
	char decoded_buf[4];
	const int n = (int)utf_utf32_to_utf8(c, (char *)&decoded_buf);

	int32_t i;
	i = 0;
	while (i < n) {
		const char c = decoded_buf[i];
		putchar_utf8_putchar(c);
		i = i + 1;
	}
}

void putchar_utf8_puts(char *s)
{
	int32_t i;
	i = 0;
	while (true) {
		const char c = s[i];
		if (c == 0) {break;}
		putchar_utf8_putchar(c);
		i = i + 1;
	}
}

void putchar_utf16_puts(uint16_t *s)
{
	int32_t i;
	i = 0;
	while (true) {
		// нельзя просто так взять и вызвать utf16_putchar
		// тк в строке может быть суррогатная пара UTF_16 символов

		const uint16_t cc16 = s[i];
		if (cc16 == 0) {
			break;
		}

		uint32_t char32;
		const uint8_t n = utf_utf16_to_utf32((uint16_t *)&s[i], &char32);
		if (n == 0) {
			break;
		}

		putchar_utf32_putchar(char32);

		i = i + (int32_t)n;
	}
}

void putchar_utf32_puts(uint32_t *s)
{
	int32_t i;
	i = 0;
	while (true) {
		const uint32_t c = s[i];
		if (c == 0) {break;}
		putchar_utf32_putchar(c);
		i = i + 1;
	}
}

