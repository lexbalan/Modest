
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./utf.h"
#include "./console.h"
#include "console.h"
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
static uint8_t ratSymbolUTF8[5] = {0xF0, 0x9F, 0x90, 0x80, 0x0};
static uint16_t ratSymbolUTF16[3] = {0xD83D, 0xDC00, 0x0};
static uint32_t ratSymbolUTF32[3] = {0x1F400, 0x0, 0x0};
static uint32_t ratSymbolUTF322[3] = {0x0, 0x0, 0x0};
#define ARR_PARTYCORN {'🎉'}
#define ARR_UNICORN {'🦄'}
#define ARR_RAT {'🐀'}
#define GENERIC_STRING_CONST "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define STRING8_CONST ((char *)GENERIC_STRING_CONST)
#define STRING16_CONST ((char16_t *)_STR16(GENERIC_STRING_CONST))
#define STRING32_CONST ((char32_t *)_STR32(GENERIC_STRING_CONST))
__attribute__((used))
static char arr_utf8[5 + 1] = {'H', 'i', '!', '\n'};
__attribute__((used))
static char16_t arr_utf16[9 + 1] = {u'H', u'e', u'l', u'l', u'o', u' ', u'Ω', u'!', u'\n'};
__attribute__((used))
static char32_t arr_utf32[8 + 1] = {U'H', U'e', U'l', U'l', U'o', U'!', U'🦄', U'\n'};

int32_t main(void) {
	char *str8 = STRING8_CONST;
	char16_t *str16 = STRING16_CONST;
	char32_t *str32 = STRING32_CONST;
	console_puts8(str8);
	console_puts8("\n");
	console_puts16(str16);
	console_puts16(u"\n");
	console_puts32(str32);
	console_puts32(U"\n");
	console_puts8(arr_utf8);
	console_puts16(arr_utf16);
	console_puts32(arr_utf32);
	console_puts8((char *)&ratSymbolUTF8);
	console_puts16((char16_t *)&ratSymbolUTF16);
	console_puts32((char32_t *)&ratSymbolUTF32);
	console_puts32(U"\n");
	console_putchar8('A');
	console_putchar16(u'Ω');
	console_putchar32(U'🦄');
	console_puts16(u"\n");
	return 0;
}

