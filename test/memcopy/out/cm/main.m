
@c_include "stdio.h"
import "lightfood/memory" as mem


type Object record {
	firstname: [32]Char8
	lastname: [32]Char8
	age: Int32
}


public func main() -> ctypes64.Int {
	stdio.printf("memcopy test\n")

	var o1: Object
	var o2: Object

	o1 = {
		firstname = "John"
		lastname = "Doe"
		age = 30
	}

	let len = sizeof(Object)
	stdio.printf("LEN = %u\n", Nat32 len)

	memory.copy(&o2, &o1, len)

	stdio.printf("firstname = '%s'\n", &(o2.firstname))
	stdio.printf("lastname = '%s'\n", &(o2.lastname))
	stdio.printf("age = %d\n", o2.age)

	return 0
}

