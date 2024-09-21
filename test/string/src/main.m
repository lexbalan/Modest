// test/string/src/main.cm

$pragma c_include "./utf.h"
$pragma c_include "./console.h"

include "libc/ctypes64"
include "libc/stdio"

import "lightfood/console"

// constants with type String(Generic)
let str8_example = "String"
let str16_example = str8_example + "-Ω"
let str32_example = str16_example + " 🐀🎉🦄"

// variables with type Array of Chars
var string8: []Char8 = str8_example
var string16: []Char16 = str16_example
var string32: []Char32 = str32_example

// variables with type Pointer to Array of Chars
var ptr_to_string8: *[]Char8 = str8_example
var ptr_to_string16: *[]Char16 = str16_example
var ptr_to_string32: *[]Char32 = str32_example


func main() -> Int {
	console.putchar_utf8("A")
	printf("\n")
	console.putchar_utf16("Ω")
	printf("\n")
	console.putchar_utf32("🦄")

	printf("\n\n")

	console.puts8(&string8)
	printf("\n")
	console.puts16(&string16)
	printf("\n")
	console.puts32(&string32)

	printf("\n\n")

	console.puts8(ptr_to_string8)
	printf("\n")
	console.puts16(ptr_to_string16)
	printf("\n")
	console.puts32(ptr_to_string32)
	printf("\n")

	return 0
}

