include "ctypes64"
include "stdio"
// tests/fixed/src/main.m

public type Fixed32 = Int32
var a: Fixed32
var b: Fixed32

const multiplier = 65536


public func fromInt16 (x: Int16) -> Fixed32 {
	return Fixed32 x * Fixed32 multiplier
}

public func print (x: Fixed32) -> Unit {
	let a: Int32 = Int32 x / multiplier
	var b: Int32 = Int32 x % multiplier
	var c: Nat32 = multiplier

	// сокращаем дробную часть
	while true {
		if (b % 2 == 0) and (c % 2 == 0) {
			b = b / 2
			c = c / 2
		} else if (b % 3 == 0) and (c % 3 == 0) {
			b = b / 3
			c = c / 3
		} else {
			break
		}
	}

	printf("%d+%d/%d\n", a, b, c)
}



public func main () -> Int {
	//printf("%s-endian\n", kind)
	a = fromInt16(10)
	print(a)

	return 0
}

