// ./out/c/console.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"








void console_putchar8(char c)
{
	console_putchar_utf8(c);
}

void console_putchar16(uint16_t c)
{
	console_putchar_utf16(c);
}

void console_putchar32(uint32_t c)
{
	console_putchar_utf32(c);
}

void console_putchar_utf8(char c)
{
	putchar((int)(int32_t)c);
}

void console_putchar_utf16(uint16_t c)
{
	uint16_t cc[2];
	cc[0] = c;
	cc[1] = 0;
	uint32_t char32;
	const uint8_t n = utf_utf16_to_utf32((uint16_t *)&cc, &char32);
	console_putchar_utf32(char32);
}

void console_putchar_utf32(uint32_t c)
{
	char decoded_buf[4];
	const int n = (int)utf_utf32_to_utf8(c, (char *)&decoded_buf);

	int32_t i;
	i = 0;
	while (i < n) {
		const char c = decoded_buf[i];
		console_putchar_utf8(c);
		i = i + 1;
	}
}

void console_puts8(char *s)
{
	int32_t i;
	i = 0;
	while (true) {
		const char c = s[i];
		if (c == 0) {break;}
		console_putchar_utf8(c);
		i = i + 1;
	}
}

void console_puts16(uint16_t *s)
{
	int32_t i;
	i = 0;
	while (true) {
		// нельзя просто так взять и вызвать putchar_utf16
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

		console_putchar_utf32(char32);

		i = i + (int32_t)n;
	}
}

void console_puts32(uint32_t *s)
{
	int32_t i;
	i = 0;
	while (true) {
		const uint32_t c = s[i];
		if (c == 0) {break;}
		console_putchar_utf32(c);
		i = i + 1;
	}
}

