// test/11.unicode/src/main.cm

$pragma c_include "./utf.h"
$pragma c_include "./console.h"

include "libc/ctypes64"
include "libc/stdio"

import "lightfood/console"


let ratSymbolUTF8 = [0xf0, 0x9f, 0x90, 0x80]
let ratSymbolUTF16 = [0xD83D, 0xDC00]
let ratSymbolUTF32 = 0x0001F400


var arr_utf8: [8]Char8 = "Hi!\n"
var arr_utf16: [8]Char16 = "Hello!\n"
var arr_utf32: [8]Char32 = "Hello!\n"


var arr_partycorn: [4]Char8 = "🎉"
let arr_unicorn: [4]Char8 = "🦄"
let arr_rat: [4]Char8 = "🐀"


let genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
let string8Const = *Str8 genericStringConst
let string16Const = *Str16 genericStringConst
let string32Const = *Str32 genericStringConst


func main() -> Int {
	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	console.puts8(str8)
	console.puts8("\n")

	console.puts16(str16)
	console.puts8("\n")

	console.puts32(str32)
	console.puts8("\n")

	console.puts8(&arr_partycorn)
	return 0
}


