
@c_include "stdio.h"


public func main() -> Int {
	let x = 127
	let y = x + 1

	stdio.("y = %i\n", Int32 y)

	if y == 128 {
		stdio.("test passed\n")
	} else {
		stdio.("test failed\n")
	}

	return 0
}

