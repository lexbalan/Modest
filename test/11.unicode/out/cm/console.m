
@c_include "./utf.h"
@c_include "./console.h"
@c_include "unistd.h"
@c_include "stdio.h"
@c_include "string.h"
import "misc/utf" as utf

//$pragma do_not_include// for Int// for write()// for putchar()// for strlen, strcpy


public func putchar8(c: Char8) -> Unit {
	putchar_utf8(c)
}


public func putchar16(c: Char16) -> Unit {
	putchar_utf16(c)
}


public func putchar32(c: Char32) -> Unit {
	putchar_utf32(c)
}



public func putchar_utf8(c: Char8) -> Unit {
	putchar(Int32 c)
}


public func putchar_utf16(c: Char16) -> Unit {
	var cc: [2]Char16
	cc[0] = c
	cc[1] = Char16 0
	var char32: Char32
	let n = utf.utf16_to_utf32(&cc, &char32)
	putchar_utf32(char32)
}


public func putchar_utf32(c: Char32) -> Unit {
	var decoded_buf: [4]Char8
	let n = Int32 utf.utf32_to_utf8(c, &decoded_buf)

	var i: Int32 = Int32 0
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
public func puts(s: *Str8) -> Unit {
	puts8(s)
}
*/

public func puts8(s: *Str8) -> Unit {
	var i: Int32 = 0
	while true {
		let c = s[i]
		if c == Char8 0 {
			break
		}
		putchar_utf8(c)
		i = i + 1
	}
}


public func puts16(s: *Str16) -> Unit {
	var i: Int32 = 0
	while true {
		// нельзя просто так взять и вызвать putchar_utf16
		// тк в строке может быть суррогатная пара UTF_16 символов

		let cc16 = s[i]
		if cc16 == Char16 0 {
			break
		}

		var char32: Char32
		let n = utf.utf16_to_utf32(*[]Char16 &(s[i]), &char32)
		if n == 0 {
			break
		}

		putchar_utf32(char32)

		i = i + Int32 n
	}
}


public func puts32(s: *Str32) -> Unit {
	var i: Int32 = 0
	while true {
		let c = s[i]
		if c == Char32 0 {
			break
		}
		putchar_utf32(c)
		i = i + 1
	}
}




public func print(form: *Str8, ...) -> Unit {
	var va: va_list
	__va_start(va, form)
	vfprint(unistd.c_STDOUT_FILENO, form, va)
	__va_end(va)
}




public func vfprint(fd: Int32, form: *Str8, va: va_list) -> Int32 {
	var strbuf: [256]Char8
	let n = vsprint(&strbuf, form, va)
	strbuf[n] = "\x0"
	write(fd, &strbuf, ctypes64.SizeT n)
	return n
}



public func vsprint(buf: *[]Char8, form: *Str8, va: va_list) -> Int32 {
	var i: Int32 = 0
	var j: Int32 = 0

	while true {
		var c: Char8 = form[i]

		if c == "\x0" {
			break
		}

		if c != "{" {

			if c == "}" {
				i = i + 1
				c = form[i]
				if c == "}" {
					buf[j] = c
					j = j + 1
					i = i + 1
				}
				again
			}

			buf[j] = c
			j = j + 1
			i = i + 1
			again
		}

		// c == '{'

		i = i + 1
		c = form[i]

		if c == "{" {
			buf[j] = "{"
			j = j + 1
			i = i + 1
			again
		}

		i = i + 2

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
			let n = sprint_dec_n32(sptr, x)
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
			j = j + Int32 strlen(s)

		} else if c == "c" {
			//
			// %c for char
			//
			let c = __va_arg(va, Char32)
			let n = Int32 utf.utf32_to_utf8(c, *[4]Char8 sptr)
			j = j + n
		}
	}

	return j
}



func n_to_dec_sym(n: Nat8) -> Char8 {
	return Char8 Nat8 Char8 "0" + n
}


func n_to_hex_sym(n: Nat8) -> Char8 {
	if n < 10 {
		return n_to_dec_sym(n)
	}
	return Char8 Nat8 Char8 "A" + n - 10
}


func sprint_hex_nat32(buf: *[]Char8, x: Nat32) -> Int32 {
	var tmpbuf: [8]Char8
	var d: Nat32 = x
	var i: Int32 = 0

	while true {
		let n = d % 16
		d = d / 16

		tmpbuf[i] = n_to_hex_sym(Nat8 n)
		i = i + 1

		if d == 0 {
			break
		}
	}

	// mirroring into buffer
	var j: Int32 = 0
	while i > 0 {
		i = i - 1
		buf[j] = tmpbuf[i]
		j = j + 1
	}

	buf[j] = "\x0"

	return j
}


func sprint_dec_int32(buf: *[]Char8, x: Int32) -> Int32 {
	var tmpbuf: [11]Char8
	var d: Int32 = x
	let neg = d < 0

	if neg {
		d = -d
	}

	var i: Int32 = 0
	while true {
		let n = d % 10
		d = d / 10
		tmpbuf[i] = n_to_dec_sym(Nat8 n)
		i = i + 1

		if d == 0 {
			break
		}
	}

	var j: Int32 = 0

	if neg {
		buf[0] = "-"
		j = j + 1
	}

	while i > 0 {
		i = i - 1
		buf[j] = tmpbuf[i]
		j = j + 1
	}

	buf[j] = "\x0"

	return j
}


func sprint_dec_n32(buf: *[]Char8, x: Nat32) -> Int32 {
	var tmpbuf: [11]Char8
	var d: Nat32 = x
	var i: Int32 = 0

	while true {
		let n = d % 10
		d = d / 10
		tmpbuf[i] = n_to_dec_sym(Nat8 n)
		i = i + 1

		if d == 0 {
			break
		}
	}

	var j: Int32 = 0
	while i > 0 {
		i = i - 1
		buf[j] = tmpbuf[i]
		j = j + 1
	}

	buf[j] = "\x0"

	return j
}

