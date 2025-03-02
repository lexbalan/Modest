// ./out/c/print.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include "print.h"



void put_str8(char *s);
void print(char *form, ...);
char n_to_sym(uint8_t n);
void sprintf_hex_nat32(char *buf, uint32_t x);
void sprintf_dec_int32(char *buf, int32_t x);
void sprintf_dec_nat32(char *buf, uint32_t x);







void put_str8(char *s)
{
	int32_t i;
	i = 0;
	while (true) {
		const char c = s[i];
		if (c == '\x0') {
			break;
		}
		putchar_putchar8(c);
		i = i + 1;
	}
}

void print(char *form, ...)
{
	va_list va;
	va_start(va, form);

	int32_t i;
	i = 0;
	while (true) {
		char c;
		c = form[i];

		if (c == '\x0') {
			break;
		}

		if (c == '\\') {
			c = form[i + 1];
			if (c == '{') {
				// "\{" -> "{"
				putchar_putchar8(c);
				i = i + 2;
				continue;
			} else if (c == '}') {
				// "\}" -> "{"
				putchar_putchar8(c);
				i = i + 2;
				continue;
			}
		}

		if (c == '{') {
			i = i + 1;
			c = form[i];
			i = i + 1;

			// буффер для печати всего, кроме строк
			char buf[10 + 1];
			char *sptr;
			sptr = (char *)&buf;
			sptr[0] = '\x0';

			if ((c == 'i') || (c == 'd')) {
				// %i & %d for signed integer (Int)
				const int32_t i = va_arg(va, int32_t);
				sprintf_dec_int32(sptr, i);
			} else if (c == 'n') {
				// %n for unsigned integer (Nat)
				const uint32_t n = va_arg(va, uint32_t);
				sprintf_dec_nat32(sptr, n);
			} else if ((c == 'x') || (c == 'p')) {
				// %x for unsigned integer (Nat)
				// %p for pointers
				const uint32_t x = va_arg(va, uint32_t);
				sprintf_hex_nat32(sptr, x);
			} else if (c == 's') {
				// %s pointer to string
				char *const s = va_arg(va, char *);
				sptr = s;
			} else if (c == 'c') {
				// %c for char
				const char c = (char)va_arg(va, int32_t);
				sptr[0] = c;
				sptr[1] = '\x0';
			}

			put_str8(sptr);

		} else {
			putchar_putchar8(c);
		}

		i = i + 1;
	}

	va_end(va);
}

char n_to_sym(uint8_t n)
{
	char c;
	if (n <= 9) {
		c = (char)((uint8_t)'0' + n);
	} else {
		c = (char)((uint8_t)'A' + n - 10);
	}
	return c;
}

void sprintf_hex_nat32(char *buf, uint32_t x)
{
	char cc[8];
	uint32_t d;
	d = x;
	int32_t i;
	i = 0;

	while (true) {
		const uint32_t n = d % 16;
		d = d / 16;

		cc[i] = n_to_sym((uint8_t)n);
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	// mirroring into buffer
	int32_t j;
	j = 0;
	while (i > 0) {
		i = i - 1;
		buf[j] = cc[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	//return buf
}

void sprintf_dec_int32(char *buf, int32_t x)
{
	char cc[11];
	int32_t d;
	d = x;
	const bool neg = d < 0;

	if (neg) {
		d = -d;
	}

	int32_t i;
	i = 0;
	while (true) {
		const int32_t n = d % 10;
		d = d / 10;
		cc[i] = n_to_sym((uint8_t)n);
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	int32_t j;
	j = 0;

	if (neg) {
		buf[0] = '-';
		j = j + 1;
	}

	while (i > 0) {
		i = i - 1;
		buf[j] = cc[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	//return buf
}

void sprintf_dec_nat32(char *buf, uint32_t x)
{
	char cc[11];
	uint32_t d;
	d = x;
	int32_t i;
	i = 0;

	while (true) {
		const uint32_t n = d % 10;
		d = d / 10;
		cc[i] = n_to_sym((uint8_t)n);
		i = i + 1;

		if (d == 0) {
			break;
		}
	}

	int32_t j;
	j = 0;
	while (i > 0) {
		i = i - 1;
		buf[j] = cc[i];
		j = j + 1;
	}

	buf[j] = '\x0';

	//return buf
}

