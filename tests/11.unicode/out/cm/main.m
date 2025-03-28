import "lightfood/console"
include "ctypes64"
include "stdio"

import "lightfood/console" as console

// include test (!)


const ratSymbolUTF8 = [0xF0, 0x9F, 0x90, 0x80]
const ratSymbolUTF16 = [0xD83D, 0xDC00]
const ratSymbolUTF32 = 0x0001F400

const arr_partycorn = "🎉"
const arr_unicorn = "🦄"
const arr_rat = "🐀"

const genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst

var arr_utf8: [8]Char8 = "Hi!\n"
var arr_utf16: [9]Char16 = "Hello Ω!\n"
var arr_utf32: [8]Char32 = "Hello!\n"


public func main() -> Int32 {
	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	console.puts8(str8)
	console.puts8("\n")

	console.puts16(str16)
	console.puts8("\n")

	console.puts32(str32)
	console.puts8("\n")

	return 0
}

