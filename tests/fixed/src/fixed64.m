
include "libc/stdio"


public type Fixed64 = @distinct Int64


// FIXIT! (Word64 Int64 1)
const multiplier = Int64 ((Word64 Int64 1) << 32)


public func add (a: Fixed64, b: Fixed64) -> Fixed64 {
	return a + b
}

public func sub (a: Fixed64, b: Fixed64) -> Fixed64 {
	return a - b
}

public func mul (a: Fixed64, b: Fixed64) -> Fixed64 {
	let a128 = unsafe Int128 a
	let b128 = unsafe Int128 b
	let v128 = a128 * b128 / Int128 multiplier
	return unsafe Fixed64 v128
}

public func div (a: Fixed64, b: Fixed64) -> Fixed64 {
	let wa = unsafe Int128 a
	let wb = unsafe Int128 b
	let v64 = (wa * Int128 multiplier) / wb
	return unsafe Fixed64 v64
}

public func fromInt32 (x: Int32) -> Fixed64 {
	return Fixed64 x * Fixed64 multiplier
}

public func toInt32 (x: Fixed64) -> Int32 {
	return unsafe Int32 (x / Fixed64 multiplier)
}

public func create (a: Int32, b: Int32, c: Int32) -> Fixed64 {
	let tail = div(fromInt32(b), fromInt32(c))
	let head = fromInt32(a)
	return add(head, tail)
}

public func print (x: Fixed64) -> Unit {
	let a = Int64 x / multiplier
	var b = Int64 x % multiplier
	var c = multiplier

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

	printf("%lld+%lld/%lld\n", a, b, c)
}


