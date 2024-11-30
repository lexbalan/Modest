// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



/* anonymous records */
#define _ratSymbolUTF8  {0xF0, 0x9F, 0x90, 0x80}
const int8_t ratSymbolUTF8[4] = _ratSymbolUTF8;
#define _ratSymbolUTF16  {0xD83D, 0xDC00}
const int16_t ratSymbolUTF16[2] = _ratSymbolUTF16;
#define ratSymbolUTF32  0x0001F400
#define _arr_partycorn  "🎉"
const char arr_partycorn[4] = _arr_partycorn;
#define _arr_unicorn  "🦄"
const char arr_unicorn[4] = _arr_unicorn;
#define _arr_rat  "🐀"
const char arr_rat[4] = _arr_rat;
#define genericStringConst  U"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string8Const  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string16Const  u"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define string32Const  U"S-t-r-i-n-g-Ω 🐀🎉🦄"











static char arr_utf8[8] = "Hi!\n";
static uint16_t arr_utf16[9] = u"Hello Ω!\n";
static uint32_t arr_utf32[8] = U"Hello!\n";

int main()
{
	char *str8;
	str8 = string8Const;
	uint16_t *str16;
	str16 = string16Const;
	uint32_t *str32;
	str32 = string32Const;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}

