
@c_include "stdio.h"


public func main() -> Int {
	stdio.("while statement test\n")

	var a: Int32 = 0
	let b = 10

	while a < b {
		stdio.("a = %d\n", a)
		a = a + 1
	}

	return 0
}

