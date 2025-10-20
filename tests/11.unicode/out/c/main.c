// tests/11.unicode/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./utf.h"
#include "./console.h"
#include <stdio.h>


// include test (!)

#define ratSymbolUTF8  {0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  {0xD83D, 0xDC00}
#define ratSymbolUTF32  0x1F400

#define arr_partycorn  "🎉"
#define arr_unicorn  "🦄"
#define arr_rat  "🐀"

#define genericStringConst  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string8Const  (genericStringConst)
#define string16Const  (_STR16(genericStringConst))
#define string32Const  (_STR32(genericStringConst))

static char arr_utf8[8] = "Hi!\n";
static char16_t arr_utf16[9] = _STR16("Hello Ω!\n");
static char32_t arr_utf32[8] = _STR32("Hello!\n");

int32_t main() {
	char *str8 = string8Const;
	char16_t *str16 = string16Const;
	char32_t *str32 = string32Const;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}


