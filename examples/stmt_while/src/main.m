// examples/stmt_while/src/main.cm

include "libc/ctypes64"
include "libc/stdio"


func main() -> Int {
	printf("while statement test\n")

	var a = 0
	let b = 10

	while a < b {
		printf("a = %d\n", a)
		a = a + 1
	}

	return 0
}

