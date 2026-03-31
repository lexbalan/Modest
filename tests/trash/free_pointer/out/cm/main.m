import "builtin"
include "ctypes64"
include "stdio"



public func main () -> Int32 {
	var a: Bool
	var b: Int32
	var c: Int64
	var freePointer: Ptr
	freePointer = &a
	freePointer = &b
	freePointer = &c
	*(*Int64 freePointer) = 123456789123456789

	printf("c = 0x%llX\n", c)
	let px = *Int64 freePointer
	let x: Int64 = *px
	printf("x = 0x%llX\n", x)

	return 0
}

