
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"


public func main() -> Int32 {
	var a: Bool
	var b: Int32
	var c: Int64

	//
	var freePointer: Ptr

	// free pointer can points to value of any type
	freePointer = &a
	freePointer = &b
	freePointer = &c

	// you can't do dereference operation with Free pointer
	// (because runtime doesn't have any idea about value type it pointee),
	// but you can construct another (non Free) pointer from it
	// and use it as usualy
	*freePointer = 0x123456789ABCDEF

	printf("c = 0x%llX\n", c)

	// Let's create new pointer to *Int64 from freePointer
	let px = freePointer

	// And will use it...
	let x = *px

	// for pointer mechanics checking
	printf("x = 0x%llX\n", x)

	return 0
}

