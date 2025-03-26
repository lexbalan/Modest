
@c_include "stdio.h"



public func main() -> Int {
	stdio.("bool check\nm")

	var x: Nat8
	var b: Bool

	x = 1
	//b = Bool x
	b = x != 0
	stdio.("x = %u\n", Word32 x)
	stdio.("x to Bool = %u\n", Word32 b)

	x = 2
	//b = Bool x
	b = x != 0
	stdio.("x = %u\n", Word32 x)
	stdio.("x to Bool = %u\n", Word32 b)

	x = 3
	//b = Bool x
	b = x != 0
	stdio.("x = %u\n", Word32 x)
	stdio.("x to Bool = %u\n", Word32 b)

	return 0
}

