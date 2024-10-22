// test/char/src/main.cm

include "libc/ctypes64"
include "libc/stdio"


let utf8Char = "s"
let utf16Char = "Я"
let utf32Char = "🐀"


public func main() -> Int {
	printf("test/char\n")

	var ch08: Char8
	var ch16: Char16
	var ch32: Char32

	ch08 = utf8Char
	ch16 = utf16Char
	ch32 = utf32Char

	//printf("ch08 = 0x%x (%c)\n", Nat32 ch08, ch08)
	//printf("ch16 = 0x%x (%c)\n", Nat32 ch16, ch16)
	//printf("ch32 = 0x%x (%c)\n", Nat32 ch32, ch32)

	return 0
}

