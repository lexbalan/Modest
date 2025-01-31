
@c_include "stdio.h"


func named_args_test(a: Int32, b: Int32, c: Int32) -> Int32 {
	return (a - b) * c
}


public func main() -> ctypes64.Int {
	stdio.printf("test named_args\n")

	let a = 25
	let b = 15
	let c = 3

	let x0 = (a - b) * c

	let x1 = named_args_test(a = a, b = b, c = c)

	if x0 == x1 {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}

	return 0
}

