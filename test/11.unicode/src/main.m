// test/11.unicode/src/main.cm

$pragma c_include "./utf.h"
$pragma c_include "./console.h"

include "libc/ctypes64"
include "libc/stdio"

// include test (!)
include "lightfood/console"


const ratSymbolUTF8 = [0xf0, 0x9f, 0x90, 0x80]
const ratSymbolUTF16 = [0xD83D, 0xDC00]
const ratSymbolUTF32 = 0x0001F400

const arr_partycorn: [4]Char8 = "🎉"
const arr_unicorn: [4]Char8 = "🦄"
const arr_rat: [4]Char8 = "🐀"

const genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst

var arr_utf8: [8]Char8 = "Hi!\n"
var arr_utf16: [9]Char16 = "Hello Ω!\n"
var arr_utf32: [8]Char32 = "Hello!\n"


public func main() -> Int {
	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	puts8(str8)
	puts8("\n")

	puts16(str16)
	puts8("\n")

	puts32(str32)
	puts8("\n")

	return 0
}

