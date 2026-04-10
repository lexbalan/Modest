
#include "utf.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
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

uint8_t utf_utf32_to_utf8(char32_t c, char *buf) {
	const uint32_t x = (uint32_t)c;
	if (x <= 127U) {
		buf[0] = (char)x;
		return 1;
	} else if (x <= 2047U) {
		const uint32_t c0 = x >> 6 & 0x1FU;
		const uint32_t c1 = x >> 0 & 0x3FU;
		buf[0] = (char)(0xC0U | c0);
		buf[1] = (char)(0x80U | c1);
		return 2;
	} else if (x <= 65535U) {
		const uint32_t c0 = x >> 12 & 0xFU;
		const uint32_t c1 = x >> 6 & 0x3FU;
		const uint32_t c2 = x >> 0 & 0x3FU;
		buf[0] = (char)(0xE0U | c0);
		buf[1] = (char)(0x80U | c1);
		buf[2] = (char)(0x80U | c2);
		return 3;
	} else if (x <= 1114111U) {
		const uint32_t c0 = x >> 18 & 0x7U;
		const uint32_t c1 = x >> 12 & 0x3FU;
		const uint32_t c2 = x >> 6 & 0x3FU;
		const uint32_t c3 = x >> 0 & 0x3FU;
		buf[0] = (char)(0xF0U | c0);
		buf[1] = (char)(0x80U | c1);
		buf[2] = (char)(0x80U | c2);
		buf[3] = (char)(0x80U | c3);
		return 4;
	}
	return 0;
}

uint8_t utf_utf16_to_utf32(char16_t *c, char32_t *result) {
	const uint32_t leading = (uint32_t)c[0];
	if (leading < 55296U || leading > 57343U) {
		*result = (char32_t)leading;
		return 1;
	} else if (leading >= 56320U) {
	} else {
		uint32_t code = (leading & 0x3FFU) << 10;
		const uint32_t trailing = (uint32_t)c[1];
		if (trailing < 56320U || trailing > 57343U) {
		} else {
			code = code | (trailing & 0x3FFU);
			*result = (char32_t)(code + 65536U);
			return 2;
		}
	}
	return 0;
}

