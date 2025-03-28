include "ctypes64"
include "stdio"



public func main() -> Int {
	stdio.printf("while statement test\n")

	var a: Int32 = 0
	let b = 10

	while a < b {
		stdio.printf("a = %d\n", a)
		a = a + 1
	}

	return 0
}

