// test/shift/src/main.cm

include "libc/ctypes64"
include "libc/stdio"


public func main() -> Int {
	printf("test shift\n")

	var c: Word32

	c = Word32 1 << 31
	printf("1 << 31 = 0x%x\n", c)

	c = Word32 0x80000000 >> 31
	printf("0x80000000 >> 31 = 0x%x\n", c)

	return 0
}
