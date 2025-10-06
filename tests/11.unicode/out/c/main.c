// tests/11.unicode/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./utf.h"
#include "./console.h"
#include <stdio.h>

#include "main.h"


// include test (!)

#define ratSymbolUTF8  {0xF0, 0x9F, 0x90, 0x80}
#define ratSymbolUTF16  {0xD83D, 0xDC00}
#define ratSymbolUTF32  0x1F400

#define arr_partycorn  "🎉"
#define arr_unicorn  "🦄"
#define arr_rat  "🐀"

#define genericStringConst  U"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string8Const  (char *)genericStringConst
#define string16Const  (uint16_t *)genericStringConst
#define string32Const  (uint32_t *)genericStringConst

static char arr_utf8[8] = "Hi!\n";
static uint16_t arr_utf16[9] = u"Hello Ω!\n";
static uint32_t arr_utf32[8] = U"Hello!\n";

int32_t main()
{
	char *str8 = string8Const;
	uint16_t *str16 = string16Const;
	uint32_t *str32 = string32Const;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}

