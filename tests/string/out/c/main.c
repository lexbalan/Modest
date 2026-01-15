
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include "uchar.h"
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

#include "./utf.h"
#include "./console.h"

#include "console.h"




// constants with type String(Generic)
#define STR8_EXAMPLE  "String"
#define STR16_EXAMPLE  STR8_EXAMPLE "-Ω"
#define STR32_EXAMPLE  STR16_EXAMPLE " 🐀🎉🦄"

// variables with type Array of Chars
static char string8[6] = STR8_EXAMPLE;
static char16_t string16[8] = _STR16(STR16_EXAMPLE);
static char32_t string32[12] = _STR32(STR32_EXAMPLE);

// variables with type Pointer to Array of Chars
static char *ptr_to_string8 = STR8_EXAMPLE;
static char16_t *ptr_to_string16 = _STR16(STR16_EXAMPLE);
static char32_t *ptr_to_string32 = _STR32(STR32_EXAMPLE);

int main(void) {
	console_putchar_utf8('A');
	printf("\n");
	console_putchar_utf16(u'Ω');
	printf("\n");
	console_putchar_utf32(U'🦄');
	printf("\n");

	printf("\n");

	console_puts8((char *)&string8);
	printf("\n");
	console_puts16((char16_t *)&string16);
	printf("\n");
	console_puts32((char32_t *)&string32);
	printf("\n");

	printf("\n");

	console_puts8(ptr_to_string8);
	printf("\n");
	console_puts16(ptr_to_string16);
	printf("\n");
	console_puts32(ptr_to_string32);
	printf("\n");

	return 0;
}


