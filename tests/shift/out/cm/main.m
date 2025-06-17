include "ctypes64"
include "stdio"
// tests/shift/src/main.m


// left must be Word
// right must be Nat

public func main () -> Int {
	printf("test shift\n")

	var c: Word32

	c = Word32 1 << 31
	printf("1 << 31 = 0x%x\n", c)

	c = Word32 0x80000000 >> 31
	printf("0x80000000 >> 31 = 0x%x\n", c)

	return 0
}

