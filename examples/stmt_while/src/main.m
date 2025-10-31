// examples/stmt_while/src/main.m

include "libc/ctypes64"
include "libc/stdio"


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

