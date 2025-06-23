
include "libc/stdio"


public type Fixed64 = @distinct Word64


// FIXIT! (Word64 Int64 1)
const multiplier = Int64 ((Word64 Int64 1) << 32)


public func add (a: Fixed64, b: Fixed64) -> Fixed64 {
	return Fixed64 (Int64 a + Int64 b)
}

public func sub (a: Fixed64, b: Fixed64) -> Fixed64 {
	return Fixed64 (Int64 a - Int64 b)
}

public func mul (a: Fixed64, b: Fixed64) -> Fixed64 {
	let a128 = unsafe Int128 a
	let b128 = unsafe Int128 b
	return unsafe Fixed64 (a128 * b128 / Int128 multiplier)
}

public func div (a: Fixed64, b: Fixed64) -> Fixed64 {
	let wa = unsafe Int128 a
	let wb = unsafe Int128 b
	return unsafe Fixed64 (wa * Int128 multiplier / wb)
}

public func fromInt32 (x: Int32) -> Fixed64 {
	return Fixed64 (Int64 x * multiplier)
}

public func toInt32 (x: Fixed64) -> Int32 {
	return unsafe Int32 (Int64 x / multiplier)
}

public func head (x: Fixed64) -> Fixed64 {
	return fromInt32(toInt32(x))
}

public func tail (x: Fixed64) -> Fixed64 {
	return sub(x, head(x))
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

	printf("%lld+%lld/%lld", a, b, c)

	let d = toInt32(x)
	let e =  Int64 tail(x) * 1000000 / multiplier
	printf(" = %d.%lld\n", d, e)
}


