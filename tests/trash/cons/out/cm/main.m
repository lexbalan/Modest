private import "builtin"
include "ctypes64"
include "stdio"



@nonstatic
func main () -> Int {
	printf("test cons operation\n")


	let a = Nat8 0xFF
	let b = Nat32 a
	printf("a = %u\n", a)
	printf("b = %u\n", b)

	return 0
}

