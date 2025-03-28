include "ctypes64"
include "stdio"



// left must be Word
// right must be Nat

public func main() -> Int {
	stdio.printf("test shift\n")

	var c: Word32

	c = Word32 1 << 31
	stdio.printf("1 << 31 = 0x%x\n", c)

	c = Word32 0x80000000 >> 31
	stdio.printf("0x80000000 >> 31 = 0x%x\n", c)

	return 0
}

