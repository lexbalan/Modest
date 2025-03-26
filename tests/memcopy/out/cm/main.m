
@c_include "stdio.h"
import "lightfood/memory" as mem


type Object record {
	firstname: [<str_value>]Char8
	lastname: [<str_value>]Char8
	age: Int32
}


public func main() -> Int {
	stdio.("memcopy test\n")

	var o1: Object
	var o2: Object

	o1 = {
		firstname = "John"
		lastname = "Doe"
		age = 30
	}

	let len = sizeof(Object)
	stdio.("LEN = %u\n", Nat32 len)

	memory.(&o2, &o1, len)

	stdio.("firstname = '%s'\n", &(o2.firstname))
	stdio.("lastname = '%s'\n", &(o2.lastname))
	stdio.("age = %d\n", o2.age)

	return 0
}

