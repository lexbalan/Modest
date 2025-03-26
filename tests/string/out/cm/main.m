
@c_include "./utf.h"
@c_include "./console.h"
@c_include "stdio.h"
import "lightfood/console" as console


// constants with type String(Generic)
const str8_example = "String"
const str16_example = str8_example + "-Ω"
const str32_example = str16_example + " 🐀🎉🦄"

// variables with type Array of Chars
var string8: [<str_value>]Char8 = str8_example
var string16: [<str_value>]Char16 = str16_example
var string32: [<str_value>]Char32 = str32_example

// variables with type Pointer to Array of Chars
var ptr_to_string8: *[]Char8 = str8_example
var ptr_to_string16: *[]Char16 = str16_example
var ptr_to_string32: *[]Char32 = str32_example


public func main() -> Int {
	console.("A")
	stdio.("\n")
	console.("Ω")
	stdio.("\n")
	console.("🦄")

	stdio.("\n\n")

	console.(&string8)
	stdio.("\n")
	console.(&string16)
	stdio.("\n")
	console.(&string32)

	stdio.("\n\n")

	console.(ptr_to_string8)
	stdio.("\n")
	console.(ptr_to_string16)
	stdio.("\n")
	console.(ptr_to_string32)
	stdio.("\n")

	return 0
}

