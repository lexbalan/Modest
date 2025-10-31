include "ctypes64"
include "stdio"
// examples/stmt_while/src/main.m


public func main () -> Int {
	printf("while statement test\n")

	var a: Nat32 = 0
	let b: Nat32 = 10

	while a < b {
		printf("a = %d\n", a)
		a = a + 1
	}

	return 0
}

