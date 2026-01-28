
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include <uchar.h>
#else
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#endif
#define __STR_UNICODE__
#define __STR8(x)  x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x)  __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#define _CHR8(x)  (__STR8(x)[0])
#define _CHR16(x) (__STR16(x)[0])
#define _CHR32(x) (__STR32(x)[0])
#endif /* __STR_UNICODE__ */




#define UTF8_CHAR  "s"
#define UTF16_CHAR  "Я"
#define UTF32_CHAR  "🐀"

int main(void) {
	printf(/*4*/"test/char\n");

	char ch08;
	char16_t ch16;
	char32_t ch32;

	ch08 = _CHR8(UTF8_CHAR);
	ch16 = _CHR16(UTF16_CHAR);
	ch32 = _CHR32(UTF32_CHAR);

	printf(/*4*/"ch08 = 0x%x (%c)\n", (uint32_t)(uint8_t)ch08, (char)ch08);
	printf(/*4*/"ch16 = 0x%x (%c)\n", (uint32_t)(uint16_t)ch16, (char16_t)ch16);
	printf(/*4*/"ch32 = 0x%x (%c)\n", (uint32_t)ch32, (char32_t)ch32);

	return 0;
}


