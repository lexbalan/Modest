
@c_include "./utf.h"
@c_include "./console.h"
@c_include "stdio.h"
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


public func main() -> ctypes64.Int {
	console.putchar_utf8("A")
	stdio.printf("\n")
	console.putchar_utf16("Ω")
	stdio.printf("\n")
	console.putchar_utf32("🦄")

	stdio.printf("\n\n")

	console.puts8(&string8)
	stdio.printf("\n")
	console.puts16(&string16)
	stdio.printf("\n")
	console.puts32(&string32)

	stdio.printf("\n\n")

	console.puts8(ptr_to_string8)
	stdio.printf("\n")
	console.puts16(ptr_to_string16)
	stdio.printf("\n")
	console.puts32(ptr_to_string32)
	stdio.printf("\n")

	return 0
}

