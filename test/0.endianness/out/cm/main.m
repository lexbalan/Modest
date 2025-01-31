
@c_include "stdio.h"


public func main() -> ctypes64.Int {
	var check: Word16 = 0x0001
	let is_le = **Word8 &check == 1

	var kind: *Str8
	if is_le {
		kind = "little"
	} else {
		kind = "big"
	}

	stdio.printf("%s-endian\n", kind)

	return 0
}

