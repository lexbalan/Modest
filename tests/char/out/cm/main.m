include "ctypes64"
include "stdio"
// tests/char/src/main.m


const utf8Char = "s"
const utf16Char = "Я"
const utf32Char = "🐀"



public func main () -> Int {
	printf("test/char\n")

	var ch08: Char8
	var ch16: Char16
	var ch32: Char32

	ch08 = utf8Char
	ch16 = utf16Char
	ch32 = utf32Char

	printf("ch08 = 0x%x (%c)\n", unsafe Nat32 unsafe Word32 unsafe Word8 ch08, ch08)
	printf("ch16 = 0x%x (%c)\n", unsafe Nat32 unsafe Word32 unsafe Word16 ch16, ch16)
	printf("ch32 = 0x%x (%c)\n", unsafe Nat32 unsafe Word32 ch32, ch32)

	return 0
}

