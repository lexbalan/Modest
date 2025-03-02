
@c_include "stdio.h"


// left must be Word
// right must be Nat

public func main() -> ctypes64.Int {
	stdio.printf("test shift\n")

	var c: Word32

	c = Word32 1 << 31
	stdio.printf("1 << 31 = 0x%x\n", c)

	c = Word32 0x80000000 >> 31
	stdio.printf("0x80000000 >> 31 = 0x%x\n", c)

	return 0
}

