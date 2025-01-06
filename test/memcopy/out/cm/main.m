
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
include "lightfood/memory"


type Object record {
	firstname: [32]Char8
	lastname: [32]Char8
	age: Int32
}


public func main() -> Int {
	printf("memcopy test\n")

	var o1: Object
	var o2: Object

	o1 = {
		firstname = "John"
		lastname = "Doe"
		age = 30
	}

	let len = sizeof(Object)
	printf("LEN = %u\n", Nat32 len)

	mcopy(&o2, &o1, len)

	printf("firstname = '%s'\n", &(o2.firstname))
	printf("lastname = '%s'\n", &(o2.lastname))
	printf("age = %d\n", o2.age)

	return 0
}

