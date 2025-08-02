// examples/0.endianness/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func init(first: *Str, mode: Int = 5, speed: Int, length: Int = 4) -> Unit {
	//
}


func hello (name: *Str8 = "World") -> Unit {
	printf("Hello %s!\n", name)
}


public func main () -> Int {
	init("S", speed=2, mode=1)

	hello("Alex")
	//hello()

	var check: Word16 = 0x0001
	let is_le = *(unsafe *Word8 &check) == 1

	var kind: *Str8
	if is_le {
		kind = "little"
	} else {
		kind = "big"
	}

	printf("%s-endian\n", kind)

	return 0
}

