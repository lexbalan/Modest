
include "libc/ctypes64"
include "libc/stdio"
func main() -> Int {
	var check: Nat16 = 0x0001
	let is_le = **Nat8 &check == 1

	var kind: *Str8
	if is_le {
		kind = "little"
	} else {
		kind = "big"
	}

	printf("%s-endian\n", kind)

	return 0
}

