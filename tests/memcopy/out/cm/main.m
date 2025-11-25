import "lightfood/memory"
include "ctypes64"
include "stdio"

import "lightfood/memory" as mem
type Object = record {
	firstname: [32]Char8
	lastname: [32]Char8
	age: Int32
}


public func main () -> Int {
	printf("memcopy test\n")

	var o1: Object
	var o2: Object

	o1 = {
		firstname = "John"
		lastname = "Doe"
		age = 30
	}

	let len: Size = sizeof(Object)
	printf("LEN = %zu\n", len)

	mem.copy(&o2, &o1, len)

	printf("firstname = '%s'\n", &o2.firstname)
	printf("lastname = '%s'\n", &o2.lastname)
	printf("age = %d\n", o2.age)

	return 0
}

