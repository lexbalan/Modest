
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
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
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
	putchar((uint32_t)c);
}

void console_putchar_utf16(char16_t c) {
	char16_t cc[2];
	__builtin_memcpy(&cc, &(char16_t [2]){c, u'\x0'}, sizeof(char16_t [2]));
	char32_t char32;
	const uint8_t console_n = utf_utf16_to_utf32(cc, &char32);
	console_putchar_utf32(char32);
}

void console_putchar_utf32(char32_t c) {
	char decoded_buf[4];
	const int32_t console_n = (int32_t)utf_utf32_to_utf8(c, decoded_buf);
	int32_t i = 0;
	while (i < console_n) {
		const char console_c = decoded_buf[i];
		console_putchar_utf8(console_c);
		i = i + 1;
	}
}
//
// puts
//

void console_puts8(char *s) {
	uint32_t i = 0U;
	while (true) {
		const char console_c = s[i];
		if (console_c == '\x0') {
			break;
		}
		console_putchar_utf8(console_c);
		i = i + 1U;
	}
}

void console_puts16(char16_t *s) {
	uint32_t i = 0U;
	while (true) {
		const char16_t console_cc16 = s[i];
		if (console_cc16 == u'\x0') {
			break;
		}
		char32_t char32;
		const uint8_t console_n = utf_utf16_to_utf32((char16_t *)&s[i], &char32);
		if (console_n == 0) {
			break;
		}
		console_putchar_utf32(char32);
		i = i + (uint32_t)console_n;
	}
}

void console_puts32(char32_t *s) {
	uint32_t i = 0U;
	while (true) {
		const char32_t console_c = s[i];
		if (console_c == U'\x0') {
			break;
		}
		console_putchar_utf32(console_c);
		i = i + 1U;
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
	const int32_t console_n = console_vsprint(strbuf, form, va);
	strbuf[console_n] = '\x0';
	write(fd, strbuf, (size_t)abs(console_n));
	return console_n;
}
static int32_t console_sprint_dec_int32(char *buf, int32_t x);
static int32_t console_sprint_dec_n32(char *buf, uint32_t x);
static int32_t console_sprint_hex_nat32(char *buf, uint32_t x);

int32_t console_vsprint(char *buf, char *form, va_list va) {
	uint32_t i = 0U;
	int32_t j = 0;
	while (true) {
		char c = form[i];
		if (c == '\x0') {
			break;
		}
		if (c != '{') {
			if (c == '}') {
				i = i + 1U;
				c = form[i];
				if (c == '}') {
					buf[j] = c;
					j = j + 1;
					i = i + 1U;
				}
				continue;
			}
			buf[j] = c;
			j = j + 1;
			i = i + 1U;
			continue;
		}
		i = i + 1U;
		c = form[i];
		if (c == '{') {
			buf[j] = '{';
			j = j + 1;
			i = i + 1U;
			continue;
		}
		i = i + 2U;
		char *const console_sptr = (char *)&buf[j];
		if (c == 'i' || c == 'd') {
			const int32_t console_x = va_arg(va, int32_t);
			const int32_t console_n = console_sprint_dec_int32(console_sptr, console_x);
			j = j + console_n;
		} else if (c == 'n') {
			const uint32_t console_x = va_arg(va, uint32_t);
			const int32_t console_n = console_sprint_dec_n32(console_sptr, console_x);
			j = j + console_n;
		} else if (c == 'x' || c == 'p') {
			const uint32_t console_x = va_arg(va, uint32_t);
			const int32_t console_n = console_sprint_hex_nat32(console_sptr, console_x);
			j = j + console_n;
		} else if (c == 's') {
			char *const console_s = va_arg(va, char *);
			strcpy(console_sptr, console_s);
			j = j + (int32_t)strlen(console_s);
		} else if (c == 'c') {
			const char32_t console_c = va_arg(va, char32_t);
			const uint8_t console_n = utf_utf32_to_utf8(console_c, (char *)console_sptr);
			j = j + (int32_t)console_n;
		}
	}
	return j;
}

__attribute__((always_inline))
static inline char console_n_to_dec_sym(uint8_t n) {
	return (char)((uint8_t)'0' + n);
}

static char console_n_to_hex_sym(uint8_t n) {
	if (n < 10) {
		return console_n_to_dec_sym(n);
	}
	return (char)((uint8_t)'A' + n - 10);
}

static int32_t console_sprint_hex_nat32(char *buf, uint32_t x) {
	char tmpbuf[8];
	uint32_t d = x;
	uint32_t i = 0U;
	while (true) {
		const uint32_t console_n = d % 16U;
		d = d / 16U;
		tmpbuf[i] = console_n_to_hex_sym((uint8_t)console_n);
		i = i + 1U;
		if (d == 0U) {
			break;
		}
	}
	int32_t j = 0;
	while (i > 0U) {
		i = i - 1U;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}
	buf[j] = '\x0';
	return j;
}

static int32_t console_sprint_dec_int32(char *buf, int32_t x) {
	char tmpbuf[11];
	int32_t d = x;
	const bool console_neg = d < 0;
	if (console_neg) {
		d = -d;
	}
	uint32_t i = 0U;
	while (true) {
		const int32_t console_n = d % 10;
		d = d / 10;
		tmpbuf[i] = console_n_to_dec_sym((uint8_t)abs(console_n));
		i = i + 1U;
		if (d == 0) {
			break;
		}
	}
	int32_t j = 0;
	if (console_neg) {
		buf[0] = '-';
		j = j + 1;
	}
	while (i > 0U) {
		i = i - 1U;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}
	buf[j] = '\x0';
	return j;
}

static int32_t console_sprint_dec_n32(char *buf, uint32_t x) {
	char tmpbuf[11];
	uint32_t d = x;
	uint32_t i = 0U;
	while (true) {
		const uint32_t console_n = d % 10U;
		d = d / 10U;
		tmpbuf[i] = console_n_to_dec_sym((uint8_t)console_n);
		i = i + 1U;
		if (d == 0U) {
			break;
		}
	}
	int32_t j = 0;
	while (i > 0U) {
		i = i - 1U;
		buf[j] = tmpbuf[i];
		j = j + 1;
	}
	buf[j] = '\x0';
	return j;
}

