
@attribute("c_no_print")
import "misc/utf"
$pragma c_include "./utf.h"


export func putchar8(c: Char8) -> Unit {
	utf8_putchar(c)
}


export func putchar16(c: Char16) -> Unit {
	utf16_putchar(c)
}


export func putchar32(c: Char32) -> Unit {
	utf32_putchar(c)
}

