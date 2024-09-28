// lightfood/console.m

$pragma do_not_include
$pragma c_include "./utf.h"
$pragma c_include "./console.h"

include "libc/ctypes64"  // for Int
include "libc/unistd"  // for write()
include "libc/stdio"   // for putchar()
include "libc/string"  // for strlen, strcpy
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
	vfprint(c_STDOUT_FILENO, form, va)
	__va_end(va)
}


export func vfprint(fd: Int, form: *Str8, va: VA_List) {
	var strbuf: [256]Char8
	let n = vsprint(&strbuf, form, va)
	strbuf[n] = '\x0'
	write(fd, &strbuf, SizeT n)
}


export func vsprint(buf: *[]Char8, form: *Str8, va: VA_List) -> Int32 {
	var i = 0  // form index
	var j = 0  // out buf index

	while true {
		var c = form[i]

		if c == "\0" {
			break
		}

		if c == "\\" {
			c = form[i + 1]
			if c == "{" {
				// "\{" -> "{"
				buf[j] = c
				++j
				i = i + 2
				again
			} else if c == "}" {
				// "\}" -> "{"
				buf[j] = c
				++j
				i = i + 2
				again
			} else if c == "\\" {
				buf[j] = c
				++j
				i = i + 2
				again
			}
		}

		if c == "{" {
			++i
			c = form[i]
			++i

			let sptr = &buf[j:]

			if c == "i" or c == "d" {
				//
				// %i & %d for signed integer (Int)
				//
				let x = __va_arg(va, Int32)
				let n = sprint_dec_int32(sptr, x)
				j = j + n

			} else if c == "n" {
				//
				// %n for unsigned integer (Nat)
				//
				let x = __va_arg(va, Nat32)
				let n = sprint_n32(sptr, x)
				j = j + n

			} else if c == "x" or c == "p" {
				//
				// %x for unsigned integer (Nat)
				// %p for pointers
				//
				let x = __va_arg(va, Nat32)
				let n = sprint_hex_nat32(sptr, x)
				j = j + n

			} else if c == "s" {
				//
				// %s pointer to string
				//
				let s = __va_arg(va, *Str8)
				strcpy(sptr, s)
				j = j + unsafe Int32 strlen(s)

			} else if c == "c" {
				//
				// %c for char
				//
				let c = __va_arg(va, Char32)
				let n = Int32 utf.utf32_to_utf8(c, unsafe *[4]Char8 &buf[j:])
				j = j + n
			}

		} else {
			buf[j] = c
			++j
		}

		++i
	}

	return j
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


func sprint_hex_nat32(buf: *[]Char8, x: Nat32) -> Int32 {
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

	return j
}


func sprint_dec_int32(buf: *[]Char8, x: Int32) -> Int32 {
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

	return j
}


func sprint_n32(buf: *[]Char8, x: Nat32) -> Int32 {
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

	return j
}

