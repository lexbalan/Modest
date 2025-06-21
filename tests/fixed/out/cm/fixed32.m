include "stdio"



public type Fixed32 = Int32

const multiplier = Int32 (Word32 1 << 16)


public func add (a: Fixed32, b: Fixed32) -> Fixed32 {
	return a + b
}

public func sub (a: Fixed32, b: Fixed32) -> Fixed32 {
	return a - b
}

public func mul (a: Fixed32, b: Fixed32) -> Fixed32 {
	let a64: Int64 = Int64 a
	let b64: Int64 = Int64 b
	let v64: Int64 = a64 * b64 / Int64 multiplier
	return Fixed32 v64
}

public func div (a: Fixed32, b: Fixed32) -> Fixed32 {
	let a64: Int64 = Int64 a
	let b64: Int64 = Int64 b
	let v64: Int64 = a64 * Int64 multiplier / b64
	return Fixed32 v64
}

public func fromInt16 (x: Int16) -> Fixed32 {
	return Fixed32 x * Fixed32 multiplier
}

public func toInt16 (x: Fixed32) -> Int16 {
	return Int16 (x / Fixed32 multiplier)
}

public func create (a: Int16, b: Int16, c: Int16) -> Fixed32 {
	let tail: Fixed32 = div(fromInt16(b), fromInt16(c))
	let head: Fixed32 = fromInt16(a)
	return add(head, tail)
}

public func print (x: Fixed32) -> Unit {
	let a: Int32 = Int32 x / multiplier
	var b: Int32 = Int32 x % multiplier
	var c: Int32 = multiplier

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

