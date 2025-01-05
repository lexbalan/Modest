


#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "utf.h"

uint8_t utf_utf32_to_utf8(uint32_t c, char *buf)
{
	uint32_t x = (uint32_t)c;

	if (x <= 0x0000007F) {
		buf[0] = (char)x;
		return 1;

	} else if (x <= 0x000007FF) {
		uint32_t y = (uint32_t)x;
		uint32_t c0 = y >> 6 & 0x1F;
		uint32_t c1 = y >> 0 & 0x3F;
		buf[0] = (char)(0xC0 | c0);
		buf[1] = (char)(0x80 | c1);
		return 2;

	} else if (x <= 0x0000FFFF) {
		uint32_t y = (uint32_t)x;
		uint32_t c0 = y >> 12 & 0x0F;
		uint32_t c1 = y >> 6 & 0x3F;
		uint32_t c2 = y >> 0 & 0x3F;
		buf[0] = (char)(0xE0 | c0);
		buf[1] = (char)(0x80 | c1);
		buf[2] = (char)(0x80 | c2);
		return 3;

	} else if (x <= 0x0010FFFF) {
		uint32_t y = (uint32_t)x;
		uint32_t c0 = y >> 18 & 0x07;
		uint32_t c1 = y >> 12 & 0x3F;
		uint32_t c2 = y >> 6 & 0x3F;
		uint32_t c3 = y >> 0 & 0x3F;
		buf[0] = (char)(0xF0 | c0);
		buf[1] = (char)(0x80 | c1);
		buf[2] = (char)(0x80 | c2);
		buf[3] = (char)(0x80 | c3);
		return 4;
	}

	return 0;
}

uint8_t utf_utf16_to_utf32(uint16_t *c, uint32_t *result)
{
	uint32_t leading = (uint32_t)c[0];

	if ((leading < 0xD800) || (leading > 0xDFFF)) {
		*result = (uint32_t)leading;
		return 1;
	} else if (leading >= 0xDC00) {
		//{'str': 'error("Illegal code sequence")'}
	} else {
		uint32_t code = ((uint32_t)leading & 0x3FF) << 10;
		uint32_t trailing = (uint32_t)c[1];
		if ((trailing < 0xDC00) || (trailing > 0xDFFF)) {
			//{'str': 'error("Illegal code sequence")'}
		} else {
			code = code | (uint32_t)trailing & 0x3FF;
			*result = (uint32_t)((uint32_t)code + 0x10000);
			return 2;
		}
	}

	return 0;
}

