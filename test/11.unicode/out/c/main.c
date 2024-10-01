// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define _main_ratSymbolUTF8  {0xF0, 0x9F, 0x90, 0x80}
const int8_t main_ratSymbolUTF8[4] = _main_ratSymbolUTF8;
#define _main_ratSymbolUTF16  {0xD83D, 0xDC00}
const int16_t main_ratSymbolUTF16[2] = _main_ratSymbolUTF16;
#define main_ratSymbolUTF32  0x0001F400
#define main_genericStringConst  U"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string8Const  "S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string16Const  u"S-t-r-i-n-g-Ω 🐀🎉🦄"
#define main_string32Const  U"S-t-r-i-n-g-Ω 🐀🎉🦄"
int main();





static char arr_utf8[8] = "Hi!\n";
static uint16_t arr_utf16[8] = u"Hello!\n";
static uint32_t arr_utf32[8] = U"Hello!\n";

int main()
{
	// indexing of GenericString returns #i symbol code
	// the symbols have GenericInteger type
	//	let omegaCharCode = "Hello Ω!\n"[6]
	//	let ratCharCode = "Hello 🐀!\n"[6]

	// you can assign omegaCharCode (937) to Nat32,
	// but you can't assign ratCharCode (128000) to Nat16 (!)
	//	var omegaCode: Nat16 = Nat16 omegaCharCode
	//	var ratCode: Nat32 = Nat32 ratCharCode

	//	printf("omegaCode = %d\n", omegaCode)
	//	printf("ratCode = %d\n", ratCode)

	/*var i = 0
	while true {
		let c = string16Const[i]

		if c == Char16 0 {
			break
		}

		printf("[%d]U16: 0x%x\n", i, Nat32 c)

		i = i + 1
	}*/

	char *str8;
	str8 = main_string8Const;
	uint16_t *str16;
	str16 = main_string16Const;
	uint32_t *str32;
	str32 = main_string32Const;

	console_puts8(str8);
	console_puts8("\n");

	console_puts16(str16);
	console_puts8("\n");

	console_puts32(str32);
	console_puts8("\n");

	return 0;
}

