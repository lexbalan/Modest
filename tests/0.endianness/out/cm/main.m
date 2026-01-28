include "ctypes64"
include "stdio"




public func main () -> Int {
	var check: Word16 = 0x0001
	let is_le: Bool = *(unsafe *Word8 &check) == 1

	var kind: *Str8
	if is_le {
		kind = "little"
	} else {
		kind = "big"
	}

	printf("%s-endian\n", *Str8 kind)

	return 0
}

