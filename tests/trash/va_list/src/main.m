// tests/va/src/main.m

include "libc/ctypes64"
include "libc/stdio"
include "libc/unistd"

//include "lightfood/print"
//pragma c_include "./print.h"

func my_printf (format: *Str8, ...) -> @unused SSizeT {
	var va: __VA_List
	var va2: __VA_List

	__va_copy(va2, va)

	__va_start(va2, format)

	let strMaxLen = 127 + 1
	var buf: [strMaxLen]Char8
	let n = vsnprintf(&buf, SizeT strMaxLen, format, va2)

	__va_end(va2)

	return write(c_STDOUT_FILENO, &buf, SizeT n)
}


public func main () -> Int {
	var k: Nat32 = 10
	my_printf("My Printf Test %u\n", k)

	let c = Char8 "$"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	my_printf("\{\}\n")
	my_printf("c = '%c'\n", c)
	my_printf("s = \"%s\"\n", s)
	my_printf("i = %i\n", i)
	my_printf("n = %i\n", n)
	my_printf("x = 0x%x\n", x)

	return 0
}

