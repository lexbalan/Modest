// lightfood/putchar.m

$pragma do_not_include

//@attribute("c_no_print")
include "misc/utf"
$pragma c_include "./utf.h"

include "libc/ctypes64"
// for putchar()
include "libc/stdio"


export func putchar8(c: Char8) -> Unit {
	utf8_putchar(c)
}


export func putchar16(c: Char16) -> Unit {
	utf16_putchar(c)
}


export func putchar32(c: Char32) -> Unit {
	utf32_putchar(c)
}



export func utf8_putchar(c: Char8) -> Unit {
	putchar(Int32 c)
}


export func utf16_putchar(c: Char16) -> Unit {
	var cc: [2]Char16
	cc[0] = c
	cc[1] = Char16 0
	var char32: Char32
	let n = utf16_to_utf32(&cc, &char32)
	utf32_putchar(char32)
}


export func utf32_putchar(c: Char32) -> Unit {
	var decoded_buf: [4]Char8
	let n = Int utf32_to_utf8(c, &decoded_buf)

	var i = 0
	while i < n {
		let c = decoded_buf[i]
		utf8_putchar(c)
		i = i + 1
	}
}


//
// puts
//

export func utf8_puts(s: *Str8) -> Unit {
	var i = 0
	while true {
		let c = s[i]
		if c == Char8 0 {break}
		utf8_putchar(c)
		i = i + 1
	}
}


export func utf16_puts(s: *Str16) -> Unit {
	var i = 0
	while true {
		// нельзя просто так взять и вызвать utf16_putchar
		// тк в строке может быть суррогатная пара UTF_16 символов

		let cc16 = s[i]
		if cc16 == Char16 0 {break}

		var char32: Char32
		let n = utf16_to_utf32(unsafe *[]Char16 &s[i], &char32)
		if n == 0 {break}

		utf32_putchar(char32)

		i = i + Int32 n
	}
}


export func utf32_puts(s: *Str32) -> Unit {
	var i = 0
	while true {
		let c = s[i]
		if c == Char32 0 {break}
		utf32_putchar(c)
		i = i + 1
	}
}

