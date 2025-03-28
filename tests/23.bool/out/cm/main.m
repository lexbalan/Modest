include "ctypes64"
include "stdio"




public func main() -> Int {
	stdio.printf("bool check\nm")

	var x: Nat8
	var b: Bool

	x = 1
	//b = Bool x
	b = x != 0
	stdio.printf("x = %u\n", Word32 x)
	stdio.printf("x to Bool = %u\n", Word32 b)

	x = 2
	//b = Bool x
	b = x != 0
	stdio.printf("x = %u\n", Word32 x)
	stdio.printf("x to Bool = %u\n", Word32 b)

	x = 3
	//b = Bool x
	b = x != 0
	stdio.printf("x = %u\n", Word32 x)
	stdio.printf("x to Bool = %u\n", Word32 b)

	return 0
}

