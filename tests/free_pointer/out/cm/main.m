include "ctypes64"
include "stdio"



public func main () -> Int32 {
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
	*(*Int64 freePointer) = 123456789123456789

	printf("c = 0x%llX\n", c)

	// Let's create new pointer to *Int64 from freePointer
	let px = *Int64 freePointer

	// And will use it...
	let x: Int64 = *px

	// for pointer mechanics checking
	printf("x = 0x%llX\n", x)

	return 0
}

