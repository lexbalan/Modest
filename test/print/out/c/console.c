
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include "console.h"

#include "./utf.h"

#include "./console.h"

#include <unistd.h>

#include <stdio.h>

#include <string.h>



//$pragma do_not_include// for Int// for write()// for putchar()// for strlen, strcpy



void console_putchar_utf8(char c);
void console_putchar8(char c)
{
	console_putchar_utf8(c);
}



void console_putchar_utf16(uint16_t c);
void console_putchar16(uint16_t c)
{
	console_putchar_utf16(c);
}



void console_putchar_utf32(uint32_t c);
void console_putchar32(uint32_t c)
{
	console_putchar_utf32(c);
}



void console_putchar_utf8(char c)
{
	putchar((int32_t)c);
}


void console_putchar_utf16(uint16_t c)
{
	uint16_t cc[2];
	memset(&cc, 0, sizeof cc);
	cc[0] = c;
	cc[1] = 0;
	uint32_t char32;
	uint8_t n = utf_utf16_to_utf32((uint16_t *)&cc, &char32);
	console_putchar_utf32(char32);
}


void console_putchar_utf32(uint32_t c)
{
	char decoded_buf[4];
	memset(&decoded_buf, 0, sizeof decoded_buf);
	int32_t n = (int32_t)utf_utf32_to_utf8(c, &decoded_buf);

	int32_t i = 0;
	while (i < n) {
		char c = decoded_buf[i];
		console_putchar_utf8(c);
		i = i + 1;
	}
}


//
// puts
//


/*
// проблема тк puts уже определен в include ^^
public func puts(s: *Str8) -> Unit {
	puts8(s)
}
*/

void console_puts8(char *s)
{
	int32_t i = 0;
	while (true) {
		char c = s[i];
		if (c == 0) {
			break;
		}
		console_putchar_utf8(c);
		i = i + 1;
	}
}


void console_puts16(uint16_t *s)
{
	int32_t i = 0;
	while (true) {
		// нельзя просто так взять и вызвать putchar_utf16
		// тк в строке может быть суррогатная пара UTF_16 символов

		uint16_t cc16 = s[i];
		if (cc16 == 0) {
			break;
		}

		uint32_t char32;
		uint8_t n = utf_utf16_to_utf32((uint16_t *)&s[i], &char32);
		if (n == 0) {
			break;
		}

		console_putchar_utf32(char32);

		i = i + (int32_t)n;
	}
}


void console_puts32(uint32_t *s)
{
	int32_t i = 0;
	while (true) {
		uint32_t c = s[i];
		if (c == 0) {
			break;
		}
		console_putchar_utf32(c);
		i = i + 1;
	}
}





int32_t console_vfprint(int fd, char *form, va_list va);
void console_print(char *form, ...)
{
	va_list va;
	va_start(va, form);
	console_vfprint(STDOUT_FILENO, form, va);
	va_end(va);
}





int32_t console_vsprint(char *buf, char *form, va_list va);
int32_t console_vfprint(int fd, char *form, va_list va)
{
	char strbuf[256];
	memset(&strbuf, 0, sizeof strbuf);
	int32_t n = console_vsprint((char *)&strbuf, form, va);
	strbuf[n] = '\x0';
	write(fd, (char *)&strbuf, ((size_t)(uint32_t)n));
	return n;
}




static int32_t sprint_dec_int32(char *buf, int32_t x);
static int32_t sprint_dec_n32(char *buf, uint32_t x);
static int32_t sprint_hex_nat32(char *buf, uint32_t x);
int32_t console_vsprint(char *buf, char *form, va_list va)
{
	int32_t i = 0;
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

		char *sptr = &buf[j];

		if (c == 'i' || c == 'd') {
			//
			// %i & %d for signed integer (Int)
			//
			int32_t x = va_arg(va, int32_t);
			int32_t n = sprint_dec_int32(sptr, x);
			j = j + n;

		} else if (c == 'n') {
			//
			// %n for unsigned integer (Nat)
			//
			uint32_t x = va_arg(va, uint32_t);
			int32_t n = sprint_dec_n32(sptr, x);
			j = j + n;

		} else if (c == 'x' || c == 'p') {
			//
			// %x for unsigned integer (Nat)
			// %p for pointers
			//
			uint32_t x = va_arg(va, uint32_t);
			int32_t n = sprint_hex_nat32(sptr, x);
			j = j + n;

		} else if (c == 's') {
			//
			// %s pointer to string
			//
			char *s = va_arg(va, char *);
			strcpy(sptr, s);
			j = j + (int32_t)strlen(s);

		} else if (c == 'c') {
			//
			// %c for char
			//
			uint32_t c = va_arg(va, uint32_t);
			int32_t n = (int32_t)utf_utf32_to_utf8(c, (char *)sptr);
			j = j + n;
		}
	}

	return j;
}



static inline char n_to_dec_sym(uint8_t n)
{
	return (char)((uint8_t)'0' + n);
}


static char n_to_hex_sym(uint8_t n)
{
	if (n < 10) {
		return n_to_dec_sym(n);
	}
	return (char)((uint8_t)'A' + n - 10);
}


static int32_t sprint_hex_nat32(char *buf, uint32_t x)
{
	char tmpbuf[8];
	memset(&tmpbuf, 0, sizeof tmpbuf);
	uint32_t d = x;
	int32_t i = 0;

	while (true) {
		uint32_t n = d % 16;
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


static int32_t sprint_dec_int32(char *buf, int32_t x)
{
	char tmpbuf[11];
	memset(&tmpbuf, 0, sizeof tmpbuf);
	int32_t d = x;
	bool neg = d < 0;

	if (neg) {
		d = -d;
	}

	int32_t i = 0;
	while (true) {
		int32_t n = d % 10;
		d = d / 10;
		tmpbuf[i] = n_to_dec_sym((uint8_t)n);
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


static int32_t sprint_dec_n32(char *buf, uint32_t x)
{
	char tmpbuf[11];
	memset(&tmpbuf, 0, sizeof tmpbuf);
	uint32_t d = x;
	int32_t i = 0;

	while (true) {
		uint32_t n = d % 10;
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

