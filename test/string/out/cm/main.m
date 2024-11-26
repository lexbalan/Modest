
@c_include "./utf.h"
@c_include "./console.h"
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
import "lightfood/console"
const str8_example = "String"
const str16_example = str8_example + "-Ω"
const str32_example = str16_example + " 🐀🎉🦄"
var string8: [6]Char8 = str8_example
var string16: [8]Char16 = str16_example
var string32: [12]Char32 = str32_example
var ptr_to_string8: *[<undefined>]Char8 = str8_example
var ptr_to_string16: *[<undefined>]Char16 = str16_example
var ptr_to_string32: *[<undefined>]Char32 = str32_example
public func main() -> Int {
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

