// test/string/src/main.cm

$pragma c_include "./utf.h"
$pragma c_include "./putchar.h"


include "libc/ctypes64"
include "libc/stdio"
import "lightfood/putchar"

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
	putchar.utf8_putchar("A")
	printf("\n")
	putchar.utf16_putchar("Ω")
	printf("\n")
	putchar.utf32_putchar("🦄")

	printf("\n\n")

	putchar.utf8_puts(&string8)
	printf("\n")
	putchar.utf16_puts(&string16)
	printf("\n")
	putchar.utf32_puts(&string32)

	printf("\n\n")

	putchar.utf8_puts(ptr_to_string8)
	printf("\n")
	putchar.utf16_puts(ptr_to_string16)
	printf("\n")
	putchar.utf32_puts(ptr_to_string32)
	printf("\n")

	return 0
}

