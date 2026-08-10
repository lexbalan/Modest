// examples/0/src/main.m

include "libc/ctypes64"
include "libc/stdio"

const ratSymbol = "🐀"

func main () -> Int {
	printf("Hello World!\n")

	//var c8: Char8 = ratSymbol[0]
	//var c16: Char16 = ratSymbol[0]
	var c32: Char32 = ratSymbol[0]

	//printf("Char8: %c\n", c8)
	//printf("Char16: %c\n", c16)
	printf("c32 = {0x%x}\n", c32)

	var a = "é"[0]
	printf("a = {0x%x}\n", a)
	return 0
}

