// lightfood/putchar.m

$pragma do_not_include
$pragma c_include "./utf.h"

import "misc/utf"

include "libc/ctypes64"
// for putchar()
include "libc/stdio"


export func putchar8(c: Char8) -> Unit {
	putchar_utf8(c)
}


export func putchar16(c: Char16) -> Unit {
	putchar_utf16(c)
}


export func putchar32(c: Char32) -> Unit {
	putchar_utf32(c)
}



export func putchar_utf8(c: Char8) -> Unit {
	putchar(Int32 c)
}


export func putchar_utf16(c: Char16) -> Unit {
	var cc: [2]Char16
	cc[0] = c
	cc[1] = Char16 0
	var char32: Char32
	let n = utf.utf16_to_utf32(&cc, &char32)
	putchar_utf32(char32)
}


export func putchar_utf32(c: Char32) -> Unit {
	var decoded_buf: [4]Char8
	let n = Int utf.utf32_to_utf8(c, &decoded_buf)

	var i = 0
	while i < n {
		let c = decoded_buf[i]
		putchar_utf8(c)
		i = i + 1
	}
}


//
// puts
//


/*
// проблема тк puts уже определен в include ^^
export func puts(s: *Str8) -> Unit {
	puts8(s)
}
*/


export func puts8(s: *Str8) -> Unit {
	var i = 0
	while true {
		let c = s[i]
		if c == Char8 0 {break}
		putchar_utf8(c)
		i = i + 1
	}
}


export func puts16(s: *Str16) -> Unit {
	var i = 0
	while true {
		// нельзя просто так взять и вызвать putchar_utf16
		// тк в строке может быть суррогатная пара UTF_16 символов

		let cc16 = s[i]
		if cc16 == Char16 0 {
			break
		}

		var char32: Char32
		let n = utf.utf16_to_utf32(unsafe *[]Char16 &s[i], &char32)
		if n == 0 {
			break
		}

		putchar_utf32(char32)

		i = i + Int32 n
	}
}


export func puts32(s: *Str32) -> Unit {
	var i = 0
	while true {
		let c = s[i]
		if c == Char32 0 {break}
		putchar_utf32(c)
		i = i + 1
	}
}

