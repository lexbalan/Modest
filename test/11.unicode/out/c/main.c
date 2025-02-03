
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
#include "./utf.h"
#include "./console.h"
#include <stdio.h>


// include test (!)


#define _main_ratSymbolUTF8  {0xF0, 0x9F, 0x90, 0x80}
uint8_t main_ratSymbolUTF8[4] = _main_ratSymbolUTF8;
#define _main_ratSymbolUTF16  {0xD83D, 0xDC00}
uint16_t main_ratSymbolUTF16[2] = _main_ratSymbolUTF16;
#define main_ratSymbolUTF32  0x0001F400

#define _main_arr_partycorn  "🎉"
char main_arr_partycorn[4] = _main_arr_partycorn;
#define _main_arr_unicorn  "🦄"
char main_arr_unicorn[4] = _main_arr_unicorn;
#define _main_arr_rat  "🐀"
char main_arr_rat[4] = _main_arr_rat;

#define main_genericStringConst  U"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string8Const  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string16Const  u"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string32Const  U"S-t-r-i-n-g-Ω 🐀🎉🦄"

static char main_arr_utf8[8] = "Hi!\n";
static uint16_t main_arr_utf16[9] = u"Hello Ω!\n";
static uint32_t main_arr_utf32[8] = U"Hello!\n";


int32_t main()
{
	char *str8 = main_string8Const;
	uint16_t *str16 = main_string16Const;
	uint32_t *str32 = main_string32Const;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}

