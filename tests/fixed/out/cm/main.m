import "fixed64"
include "ctypes64"
include "stdio"
// tests/fixed/src/main.m
import "fixed64" as fixed



public func main () -> Int {
	//printf("%s-endian\n", kind)
	let a: Fixed64 = fixed.fromInt32(-10)
	let b: Fixed64 = fixed.fromInt32(3)
	let pi: Fixed64 = fixed.create(3, 141592, 1000000)

	var y = Nat64 0x1FFFFFFFF

	printf("pi (%llx):\n", pi)
	fixed.print(pi)

	printf("div:\n")
	let c: Fixed64 = fixed.div(a, b)
	fixed.print(c)

	printf("mul:\n")
	let d: Fixed64 = fixed.mul(a, b)
	fixed.print(d)

	printf("add:\n")
	let e: Fixed64 = fixed.add(a, b)
	fixed.print(e)

	printf("sub:\n")
	let f: Fixed64 = fixed.sub(a, b)
	fixed.print(f)

	var i: Int32 = fixed.toInt32(c)
	printf("i = %d\n", i)

	let x: Fixed64 = fixed.create(1, 3, 2)
	fixed.print(x)

	return 0
}

