// utf.m
// algorithms from wikipedia
// (https://ru.wikipedia.org/wiki/UTF-16)

pragma do_not_include
pragma unsafe


// декодирует символ UTF-32 в последовательность UTF-8
public func utf32_to_utf8 (c: Char32, buf: *[4]Char8) -> Nat8 {
	let x = Word32 c

	if Nat32 x <= Nat32 0x0000007F {
		buf[0] = unsafe Char8 x
		return 1

	} else if Nat32 x <= Nat32 0x000007FF {
		let c0 = (x >> 6) and 0x1F
		let c1 = (x >> 0) and 0x3F
		buf[0] = unsafe Char8 (0xC0 or c0)
		buf[1] = unsafe Char8 (0x80 or c1)
		return 2

	} else if Nat32 x <= Nat32 0x0000FFFF {
		let c0 = (x >> 12) and 0x0F
		let c1 = (x >> 06) and 0x3F
		let c2 = (x >> 00) and 0x3F
		buf[0] = unsafe Char8 (0xE0 or c0)
		buf[1] = unsafe Char8 (0x80 or c1)
		buf[2] = unsafe Char8 (0x80 or c2)
		return 3

	} else if Nat32 x <= Nat32 0x0010FFFF {
		let c0 = (x >> 18) and 0x07
		let c1 = (x >> 12) and 0x3F
		let c2 = (x >> 06) and 0x3F
		let c3 = (x >> 00) and 0x3F
		buf[0] = unsafe Char8 (0xF0 or c0)
		buf[1] = unsafe Char8 (0x80 or c1)
		buf[2] = unsafe Char8 (0x80 or c2)
		buf[3] = unsafe Char8 (0x80 or c3)
		return 4
	}

	return 0
}


// returns n-symbols from input stream
public func utf16_to_utf32 (c: *[]Char16, result: *Char32) -> Nat8 {
	let leading = Word32 c[0]

	if (Nat32 leading < Nat32 0xD800) or (Nat32 leading > Nat32 0xDFFF) {
		*result = Char32 leading
		return 1
	} else if Nat32 leading >= Nat32 0xDC00 {
		//error("Illegal code sequence")
	} else {
		var code = (leading and 0x3FF) << 10
		let trailing = Word32 c[1]
		if (Nat32 trailing < Nat32 0xDC00) or (Nat32 trailing > Nat32 0xDFFF) {
			//error("Illegal code sequence")
		} else {
			code = code or (trailing and 0x3FF)
			*result = Char32 Word32 (Nat32 code + Nat32 0x10000)
			return 2
		}
	}

	return 0
}

