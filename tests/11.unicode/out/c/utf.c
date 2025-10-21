// utf.m
// algorithms from wikipedia
// (https://ru.wikipedia.org/wiki/UTF-16)

#include "utf.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>



// декодирует символ UTF-32 в последовательность UTF-8
uint8_t utf_utf32_to_utf8(char32_t c, char *buf) {
	const uint32_t x = (uint32_t)c;

	if (x <= 0x7F) {
		buf[0] = (char)x;
		return 1;
	} else if (x <= 0x7FF) {
		const uint32_t c0 = (x >> 6) & 0x1F;
		const uint32_t c1 = (x >> 0) & 0x3F;
		buf[0] = (char)(0xC0 | c0);
		buf[1] = (char)(0x80 | c1);
		return 2;
	} else if (x <= 0xFFFF) {
		const uint32_t c0 = (x >> 12) & 0xF;
		const uint32_t c1 = (x >> 6) & 0x3F;
		const uint32_t c2 = (x >> 0) & 0x3F;
		buf[0] = (char)(0xE0 | c0);
		buf[1] = (char)(0x80 | c1);
		buf[2] = (char)(0x80 | c2);
		return 3;
	} else if (x <= 0x10FFFF) {
		const uint32_t c0 = (x >> 18) & 0x7;
		const uint32_t c1 = (x >> 12) & 0x3F;
		const uint32_t c2 = (x >> 6) & 0x3F;
		const uint32_t c3 = (x >> 0) & 0x3F;
		buf[0] = (char)(0xF0 | c0);
		buf[1] = (char)(0x80 | c1);
		buf[2] = (char)(0x80 | c2);
		buf[3] = (char)(0x80 | c3);
		return 4;
	}

	return 0;
}


// returns n-symbols from input stream
uint8_t utf_utf16_to_utf32(char16_t *c, char32_t *result) {
	const uint32_t leading = (uint32_t)c[0];

	if ((leading < 0xD800) || (leading > 0xDFFF)) {
		*result = (char32_t)leading;
		return 1;
	} else if (leading >= 0xDC00) {
		//error("Illegal code sequence")
	} else {
		uint32_t code = (leading & 0x3FF) << 10;
		const uint32_t trailing = (uint32_t)c[1];
		if ((trailing < 0xDC00) || (trailing > 0xDFFF)) {
			//error("Illegal code sequence")
		} else {
			code = code | (trailing & 0x3FF);
			*result = (char32_t)(code + 0x10000);
			return 2;
		}
	}

	return 0;
}


