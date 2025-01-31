
@c_include "stdio.h"


public func main() -> ctypes64.Int {
	let x = 127
	let y = x + 1

	stdio.printf("y = %i\n", Int32 y)

	if y == 128 {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}

	return 0
}

