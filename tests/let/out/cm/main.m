include "ctypes64"
include "stdio"



public func main () -> Int {
	let x = 127
	let y = x + 1

	printf("y = %i\n", Int32 Int32 y)

	if y == 128 {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

