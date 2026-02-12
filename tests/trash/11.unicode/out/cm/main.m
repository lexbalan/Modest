import "lightfood/console"
include "ctypes64"
include "stdio"

import "lightfood/console" as console


var ratSymbolUTF8: [5]Word8 = [0xF0, 0x9F, 0x90, 0x80]
var ratSymbolUTF16: [3]Word16 = [0xD83D, 0xDC00]
var ratSymbolUTF32: [3]Word32 = [0x0001F400]
var ratSymbolUTF322: [3]Word32 = []

const arr_partycorn: [4]Char8 = "🎉"
const arr_unicorn: [4]Char8 = "🦄"
const arr_rat: [4]Char8 = "🐀"

const genericStringConst = "S-t-r-i-n-g-Ω 🐀🎉🦄"
const string8Const = *Str8 genericStringConst
const string16Const = *Str16 genericStringConst
const string32Const = *Str32 genericStringConst



@used
var arr_utf8: [5 + 1]Char8 = "Hi!\n"

@used
var arr_utf16: [9 + 1]Char16 = "Hello Ω!\n"

@used
var arr_utf32: [8 + 1]Char32 = "Hello!🦄\n"


public func main () -> Int32 {
	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	console.puts8(str8)
	console.puts8("\n")

	console.puts16(str16)
	console.puts16("\n")

	console.puts32(str32)
	console.puts32("\n")

	console.puts8(&arr_utf8)
	console.puts16(&arr_utf16)
	console.puts32(&arr_utf32)

	console.puts8(unsafe *Str8 &ratSymbolUTF8)
	console.puts16(unsafe *Str16 &ratSymbolUTF16)
	console.puts32(unsafe *Str32 &ratSymbolUTF32)
	console.puts32("\n")

	console.putchar8("A")
	console.putchar16("Ω")
	console.putchar32("🦄")

	console.puts16("\n")

	return 0
}

