include "ctypes64"
include "stdio"
// examples/0.endianness/src/main.m



func init (first: *Str, mode: Int, speed: Int, length: Int) -> Unit {
	//
}


func hello (name: *Str8) -> Unit {
	printf("Hello %s!\n", name)
}


public func main () -> Int {
	init("S", mode=1, speed=2, length=4)

	hello("Alex")
	//hello()

	var check: Word16 = 0x0001
	let is_le: Bool = *(unsafe *Word8 &check) == 1

	var kind: *Str8
	if is_le {
		kind = "little"
	} else {
		kind = "big"
	}

	printf("%s-endian\n", kind)

	return 0
}

