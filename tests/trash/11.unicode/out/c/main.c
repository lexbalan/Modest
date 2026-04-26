
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
static uint8_t main_ratSymbolUTF8[5] = {0xF0, 0x9F, 0x90, 0x80, 0x0};
static uint16_t main_ratSymbolUTF16[3] = {0xD83D, 0xDC00, (uint16_t)0};
static uint32_t main_ratSymbolUTF32[3] = {0x1F400U, (uint32_t)0, (uint32_t)0};
static uint32_t main_ratSymbolUTF322[3] = {0x0U, 0x0U, 0x0U};
#define MAIN_ARR_PARTYCORN {'🎉'}
#define MAIN_ARR_UNICORN {'🦄'}
#define MAIN_ARR_RAT {'🐀'}
#define MAIN_GENERIC_STRING_CONST "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define MAIN_STRING8_CONST MAIN_GENERIC_STRING_CONST
#define MAIN_STRING16_CONST (_STR16(MAIN_GENERIC_STRING_CONST))
#define MAIN_STRING32_CONST (_STR32(MAIN_GENERIC_STRING_CONST))
__attribute__((used))
static char main_arr_utf8[5 + 1] = {'H', 'i', '!', '\n'};
__attribute__((used))
static char16_t main_arr_utf16[9 + 1] = {u'H', u'e', u'l', u'l', u'o', u' ', u'Ω', u'!', u'\n'};
__attribute__((used))
static char32_t main_arr_utf32[8 + 1] = {U'H', U'e', U'l', U'l', U'o', U'!', U'🦄', U'\n'};

int32_t main(void) {
	char *str8 = MAIN_STRING8_CONST;
	char16_t *str16 = MAIN_STRING16_CONST;
	char32_t *str32 = MAIN_STRING32_CONST;
	console_puts8(str8);
	console_puts8("\n");
	console_puts16(str16);
	console_puts16(u"\n");
	console_puts32(str32);
	console_puts32(U"\n");
	console_puts8(main_arr_utf8);
	console_puts16(main_arr_utf16);
	console_puts32(main_arr_utf32);
	console_puts8((char *)&main_ratSymbolUTF8);
	console_puts16((char16_t *)&main_ratSymbolUTF16);
	console_puts32((char32_t *)&main_ratSymbolUTF32);
	console_puts32(U"\n");
	console_putchar8('A');
	console_putchar16(u'Ω');
	console_putchar32(U'🦄');
	console_puts16(u"\n");
	return 0;
}

