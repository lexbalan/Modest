
@c_include "stdio.h"



public func main() -> ctypes64.Int {
	printf("bool check\nm")

	var x: Nat8
	var b: Bool

	x = 1
	//b = Bool x
	b = x != 0
	printf("x = %u\n", Nat32 x)
	printf("x to Bool = %u\n", Nat32 b)

	x = 2
	//b = Bool x
	b = x != 0
	printf("x = %u\n", Nat32 x)
	printf("x to Bool = %u\n", Nat32 b)

	x = 3
	//b = Bool x
	b = x != 0
	printf("x = %u\n", Nat32 x)
	printf("x to Bool = %u\n", Nat32 b)

	return 0
}

