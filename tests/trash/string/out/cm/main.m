private import "builtin"
private import "lightfood/console"
include "ctypes64"
include "stdio"

import "lightfood/console" as console


// constants with type String(Generic)
const str8_example = "String"
const str16_example = str8_example + "-Ω"
const str32_example = str16_example + " 🐀🎉🦄"

// variables with type Array of Chars
var string8: [6]Char8 = str8_example
var string16: [8]Char16 = str16_example
var string32: [12]Char32 = str32_example

// variables with type Pointer to Array of Chars
var ptr_to_string8: *[]Char8 = str8_example
var ptr_to_string16: *[]Char16 = str16_example
var ptr_to_string32: *[]Char32 = str32_example


public func main () -> Int {
	putchar_utf8("A")
	printf("\n")
	putchar_utf16("Ω")
	printf("\n")
	putchar_utf32("🦄")
	printf("\n")

	printf("\n")

	puts8(&string8)
	printf("\n")
	puts16(&string16)
	printf("\n")
	puts32(&string32)
	printf("\n")

	printf("\n")

	puts8(ptr_to_string8)
	printf("\n")
	puts16(ptr_to_string16)
	printf("\n")
	puts32(ptr_to_string32)
	printf("\n")

	return 0
}

