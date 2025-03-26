
@c_include "./utf.h"
@c_include "./console.h"
@c_include "stdio.h"
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

var arr_utf8: [<str_value>]Char8 = "Hi!\n"
var arr_utf16: [<str_value>]Char16 = "Hello Ω!\n"
var arr_utf32: [<str_value>]Char32 = "Hello!\n"


public func main() -> Int32 {
	var str8: *Str8 = string8Const
	var str16: *Str16 = string16Const
	var str32: *Str32 = string32Const

	console.(str8)
	console.("\n")

	console.(str16)
	console.("\n")

	console.(str32)
	console.("\n")

	return 0
}

