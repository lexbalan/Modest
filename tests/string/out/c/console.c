
#include "console.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include "./utf.h"
#include "./console.h"

#include <stdarg.h>
#include <stdlib.h>



void console_putchar_utf8(char c);

void console_putchar8(char c) {
	console_putchar_utf8(c);
}



void console_putchar_utf16(char16_t c);

void console_putchar16(char16_t c) {
	console_putchar_utf16(c);
}



void console_putchar_utf32(char32_t c);

void console_putchar32(char32_t c) {
	console_putchar_utf32(c);
}


void console_putchar_utf8(char c) {
	putchar((int32_t)(uint32_t)c);
}


void console_putchar_utf16(char16_t c) {
	char16_t cc[2];
	memcpy(&cc, &(char16_t[2]){c, u'\x0'}, sizeof(char16_t[2]));
	char32_t char32;
	const uint8_t n = utf_utf16_to_utf32((char16_t *)&cc, &char32);
	console_putchar_utf32(char32);
}


void console_putchar_utf32(char32_t c) {
	char decoded_buf[4];
	const int32_t n = (int32_t)utf_utf32_to_utf8(c, (char *)&decoded_buf);

	int32_t i = 0;
	while (i < n) {
		const char c = decoded_buf[i];
		console_putchar_utf8(c);
		i = i + 1;
	}
}



/*
// проблема тк puts уже определен в include ^^
public func puts(s: *Str8) -> Unit {
	puts8(s)
}
*/

void console_puts8(char *s) {
	uint32_t i = 0;
	while (true) {
		const char c = s[i];
		if (c == '\x0') {
			break;
		}
		console_putchar_utf8(c);
		i = i + 1;
	}
}


void console_puts16(char16_t *s) {
	uint32_t i = 0;
	while (true) {
		// нельзя просто так взять и вызвать putchar_utf16
		// тк в строке может быть суррогатная пара UTF_16 символов

		const char16_t cc16 = s[i];
		if (cc16 == u'\x0') {
			break;
		}

		char32_t char32;
		const uint8_t n = utf_utf16_to_utf32((char16_t *)&s[i], &char32);
		if (n == 0) {
			break;
		}

		console_putchar_utf32(char32);

		i = i + (uint32_t)n;
	}
}


void console_puts32(char32_t *s) {
	uint32_t i = 0;
	while (true) {
		const char32_t c = s[i];
		if (c == U'\x0') {
			break;
		}
		console_putchar_utf32(c);
		i = i + 1;
	}
}



int32_t console_vfprint(int32_t fd, char *form, va_list va);

void console_print(char *form, ...) {
	va_list va;
	va_start(va, form);
	console_vfprint(STDOUT_FILENO, form, va);
	va_end(va);
}



int32_t console_vsprint(char *buf, char *form, va_list va);

int32_t console_vfprint(int32_t fd, char *form, va_list va) {
	char strbuf[256];
	const int32_t n = console_vsprint((char *)&strbuf, form, va);
	strbuf[n] = '\x0';
	write(fd, (void *)&strbuf, (size_t)abs((int)n));
	return n;
}



static int32_t sprint_dec_int32(char *buf, int32_t x);
static int32_t sprint_dec_n32(char *buf, uint32_t x);
static int32_t sprint_hex_nat32(char *buf, uint32_t x);

int32_t console_vsprint(char *buf, char *form, va_list va) {
	uint32_t i = 0;
	int32_t j = 0;

	while (true) {
		char c = form[i];

		if (c == '\x0') {
			break;
		}

		if (c != '{') {

			if (c == '}') {
				i = i + 1;
				c = form[i];
				if (c == '}') {
					buf[j] = c;
					j = j + 1;
					i = i + 1;
				}
				continue;
			}

			buf[j] = c;
			j = j + 1;
			i = i + 1;
			continue;
		}

		// c == '{'

		i = i + 1;
		c = form[i];

		if (c == '{') {
			buf[j] = '{';
			j = j + 1;
			i = i + 1;
			continue;
		}

		i = i + 2;

		char *const sptr = &buf[j];

		if (c == 'i' || c == 'd') {
			//
			// %i & %d for signed integer (Int)
			//
			const int32_t x = va_arg(va, int32_t);
			const int32_t n = sprint_dec_int32(sptr, x);
			j = j + n;
		} else if (c == 'n') {
			//
			// %n for unsigned integer (Nat)
			//
			const uint32_t x = va_arg(va, uint32_t);
			const int32_t n = sprint_dec_n32(sptr, x);
			j = j + n;
		} else if (c == 'x' || c == 'p') {
			//
			// %x for unsigned integer (Nat)
			// %p for pointers
			//
			const uint32_t x = va_arg(va, uint32_t);
			const int32_t n = sprint_hex_nat32(sptr, x);
			j = j + n;
		} else if (c == 's') {
			//
			// %s pointer to string
			//
			char *const s = va_arg(va, char *);
			strcpy(sptr, s);
			j = j + (int32_t)strlen(s);
		} else if (c == 'c') {
			//
			// %c for char
			//
			const char32_t c = va_arg(va, char32_t);
			const uint8_t n = utf_utf32_to_utf8(c, (char *)(char *)sptr);
			j = j + (int32_t)n;
		}
	}

	return j;
}


__attribute__((always_inline))
static inline char n_to_dec_sym(uint8_t n) {
	return (char)((uint8_t)'0' + n);
}


static char n_to_hex_sym(uint8_t n) {
	if (n < 10) {
		return n_to_dec_sym(n);
	}
	return (char)((uint8_t)'A' + (n - 10));
}


static int32_t sprint_hex_nat32(char *buf, uint32_t x) {
	char tmpbuf[8];
	uint32_t d = x;
	uint32_t i = 0;

	while (true) {
		const uint32_t n = d % 16;
		d = d / 16;

		tmpbuf[i] = n_to_hex_sym((uint8_t)n);
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	// mirroring into buffer
	int32_t j = 0;
	while (i > 0) {
		i = i - 1;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	return j;
}


static int32_t sprint_dec_int32(char *buf, int32_t x) {
	char tmpbuf[11];
	int32_t d = x;
	const bool neg = d < 0;

	if (neg) {
		d = -d;
	}

	uint32_t i = 0;
	while (true) {
		const int32_t n = d % 10;
		d = d / 10;
		tmpbuf[i] = n_to_dec_sym((uint8_t)abs((int)n));
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	int32_t j = 0;

	if (neg) {
		buf[0] = '-';
		j = j + 1;
	}

	while (i > 0) {
		i = i - 1;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	return j;
}


static int32_t sprint_dec_n32(char *buf, uint32_t x) {
	char tmpbuf[11];
	uint32_t d = x;
	uint32_t i = 0;

	while (true) {
		const uint32_t n = d % 10;
		d = d / 10;
		tmpbuf[i] = n_to_dec_sym((uint8_t)n);
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	int32_t j = 0;
	while (i > 0) {
		i = i - 1;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	return j;
}


