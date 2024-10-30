
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"


type Object record {
	firstname: [32]Char8
	lastname: [32]Char8
	age: Int32
}
func memcopy(dst: Ptr, src: Ptr, len: Nat32) -> Unit {
	// not worked now!
	//([len]Word8 dst) = ([len]Word8 src)
}
public func main() -> Int {
	printf("memcopy test\n")

	var o1: Objectvar o2: Object

	o1.firstname = "John"
	o1.lastname = "Doe"
	o1.age = 30

	let len = sizeof(Object)
	printf("LEN = %u\n", Nat32 len)

	o2 = o1

	printf("firstname = '%s'\n", &o2.firstname)
	printf("lastname = '%s'\n", &o2.lastname)
	printf("age = %d\n", o2.age)

	return 0
}

