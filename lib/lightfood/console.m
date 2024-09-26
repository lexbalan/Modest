// lightfood/console.m

$pragma do_not_include
$pragma c_include "./utf.h"
$pragma c_include "./console.h"

include "libc/stdio"  // for putchar()
import "misc/utf"


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
	let n = Int32 utf.utf32_to_utf8(c, &decoded_buf)

	var i = Int32 0
	while i < n {
		let c = decoded_buf[i]
		putchar_utf8(c)
		++i
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
		if c == Char8 0 {
			break
		}
		putchar_utf8(c)
		++i
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
		++i
	}
}


export func print(form: *Str8, ...) {
	var va: VA_List
	__va_start(va, form)

	var i = 0
	while true {
		var c = form[i]

		if c == "\0" {
			break
		}

		if c == "\\" {
			c = form[i + 1]
			if c == "{" {
				// "\{" -> "{"
				putchar8(c)
				i = i + 2
				again
			} else if c == "}" {
				// "\}" -> "{"
				putchar8(c)
				i = i + 2
				again
			} else if c == "\\" {
				putchar8("\\")
				i = i + 2
				again
			}
		}

		if c == "{" {
			++i
			c = form[i]
			++i

			// буффер для печати всего, кроме строк
			var buf: [10+1]Char8
			var sptr: *[]Char8
			sptr = &buf
			sptr[0] = "\0"

			if (c == "i") or (c == "d") {
				//
				// %i & %d for signed integer (Int)
				//
				let i = __va_arg(va, Int32)
				sprintf_dec_int32(sptr, i)
			} else if c == "n" {
				//
				// %n for unsigned integer (Nat)
				//
				let n = __va_arg(va, Nat32)
				sprintf_dec_nat32(sptr, n)
			} else if (c == "x") or (c == "p") {
				//
				// %x for unsigned integer (Nat)
				// %p for pointers
				//
				let x = __va_arg(va, Nat32)
				sprintf_hex_nat32(sptr, x)
			} else if c == "s" {
				//
				// %s pointer to string
				//
				let s = __va_arg(va, *Str8)
				sptr = s
			} else if c == "c" {
				//
				// %c for char
				//
				let c = __va_arg(va, Char32)
				sptr[0] = unsafe Char8 c
				sptr[1] = "\0"
			}

			puts8(sptr)

		} else {
			putchar8(c)
		}

		++i
	}

	__va_end(va)
}


func n_to_sym(n: Nat8) -> Char8 {
	var c: Char8
	if n <= 9 {
		c = Char8 (Nat8 Char8 "0" + n)
	} else {
		c = Char8 (Nat8 Char8 "A" + (n - 10))
	}
	return c
}


func sprintf_hex_nat32(buf: *[]Char8, x: Nat32) {
	var cc: [8]Char8
	var d = x
	var i = 0

	while true {
		let n = d % 16
		d = d / 16

		cc[i] = n_to_sym(unsafe Nat8 n)
		++i

		if d == 0 {
			break
		}
	}

	// mirroring into buffer
	var j = 0
	while i > 0 {
		--i
		buf[j] = cc[i]
		++j
	}

	buf[j] = "\0"

	//return buf
}


func sprintf_dec_int32(buf: *[]Char8, x: Int32) {
	var cc: [11]Char8
	var d = x
	let neg = d < 0

	if neg {
		d = -d
	}

	var i = 0
	while true {
		let n = d % 10
		d = d / 10
		cc[i] = n_to_sym(unsafe Nat8 n)
		++i

		if d == 0 {
			break
		}
	}

	var j = 0

	if neg {
		buf[0] = "-"
		++j
	}

	while i > 0 {
		--i
		buf[j] = cc[i]
		++j
	}

	buf[j] = "\0"

	//return buf
}


func sprintf_dec_nat32(buf: *[]Char8, x: Nat32) {
	var cc: [11]Char8
	var d = x
	var i = 0

	while true {
		let n = d % 10
		d = d / 10
		cc[i] = n_to_sym(unsafe Nat8 n)
		++i

		if d == 0 {
			break
		}
	}

	var j = 0
	while i > 0 {
		--i
		buf[j] = cc[i]
		++j
	}

	buf[j] = "\0"

	//return buf
}

