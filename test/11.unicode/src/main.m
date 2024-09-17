// test/11.unicode/src/main.cm

$pragma c_include "./utf.h"
$pragma c_include "./putchar.h"

include "libc/ctypes64"
include "libc/stdio"

import "lightfood/putchar"


let ratSymbolUTF8 = [0xf0, 0x9f, 0x90, 0x80]
let ratSymbolUTF16 = [0xD83D, 0xDC00]
let ratSymbolUTF32 = 0x0001F400


var arr_utf8: [8]Char8 = [8]Char8 "Hi!\n"
var arr_utf16: [8]Char16 = "Hello!\n"
var arr_utf32: [8]Char32 = "Hello!\n"


let genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
let string8Const = *Str8 genericStringConst
let string16Const = *Str16 genericStringConst
let string32Const = *Str32 genericStringConst


func main() -> Int {
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

	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	putchar.utf8_puts(str8)
	putchar.utf8_puts("\n")

	putchar.utf16_puts(str16)
	putchar.utf8_puts("\n")

	putchar.utf32_puts(str32)
	putchar.utf8_puts("\n")

	return 0
}


