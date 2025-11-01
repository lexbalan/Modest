// tests/11.unicode/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./utf.h"
#include "./console.h"



// include test (!)

#define RAT_SYMBOL_UTF8  {0xF0, 0x9F, 0x90, 0x80}
#define RAT_SYMBOL_UTF16  {0xD83D, 0xDC00}
#define RAT_SYMBOL_UTF32  0x1F400

#define ARR_PARTYCORN  "🎉"
#define ARR_UNICORN  "🦄"
#define ARR_RAT  "🐀"

#define GENERIC_STRING_CONST  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define STRING8_CONST  (GENERIC_STRING_CONST)
#define STRING16_CONST  (_STR16(GENERIC_STRING_CONST))
#define STRING32_CONST  (_STR32(GENERIC_STRING_CONST))

__attribute__((used))
static char arr_utf8[8] = "Hi!\n";

__attribute__((used))
static char16_t arr_utf16[9] = _STR16("Hello Ω!\n");

__attribute__((used))
static char32_t arr_utf32[8] = _STR32("Hello!\n");

int32_t main(void) {
	char *str8 = STRING8_CONST;
	char16_t *str16 = STRING16_CONST;
	char32_t *str32 = STRING32_CONST;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}


