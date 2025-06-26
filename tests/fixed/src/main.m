// tests/fixed/src/main.m

include "libc/ctypes64"
include "libc/stdio"

import "fixed64" as fixed


public func main () -> Int {
	//printf("%s-endian\n", kind)
	let a = fixed.fromInt32(-10)
	let b = fixed.fromInt32(3)
	let pi = fixed.create(3, 141592, 1000000)

	const u = Int32 5

	var y = Nat64 0x1FFFFFFFF
	var z = Int64 0x1FFFFFFFF

	printf("pi (%llx):\n", pi)
	fixed.print(pi)

	printf("div:\n")
	let c = fixed.div(a, b)
	fixed.print(c)

	printf("mul:\n")
	let d = fixed.mul(a, b)
	fixed.print(d)

	printf("add:\n")
	let e = fixed.add(a, b)
	fixed.print(e)

	printf("sub:\n")
	let f = fixed.sub(a, b)
	fixed.print(f)

	var i: Int32 = fixed.toInt32(c)
	printf("i = %d\n", i)

	let x = fixed.create(1, 3, 2)
	fixed.print(x)

	return 0
}


