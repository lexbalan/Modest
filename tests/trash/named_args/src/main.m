// tests/named_args/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func named_args_test (a: Int32, b: Int32, c: Int32) -> Int32 {
	return (a - b) * c
}


public func main () -> Int {
	printf("test named_args\n")

	let a = 25
	let b = 15
	let c = 3

	let x0 = (a - b) * c

	let x1 = named_args_test(
		c = c
		a = a
		b = b
	)

	if x0 == x1 {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

