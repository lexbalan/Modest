include "ctypes64"
include "stdio"
include "unistd"
// tests/va/src/main.m

//include "lightfood/print"
//pragma c_include "./print.h"

func my_printf (format: *Str8, ...) -> SSizeT {
	var va: va_list
	var va2: va_list

	__va_copy(va2, va)

	__va_start(va2, format)

	let strMaxLen = 127 + 1
	var buf: [strMaxLen]Char8
	let n: Int = vsnprintf(&buf, SizeT strMaxLen, format, va2)

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

	my_printf("\x0\x0\n")
	my_printf("c = '%c'\n", c)
	my_printf("s = \"%s\"\n", s)
	my_printf("i = %i\n", i)
	my_printf("n = %i\n", n)
	my_printf("x = 0x%x\n", x)

	return 0
}

