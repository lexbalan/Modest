
include "libc/stdio"


public type Fixed32 = @distinct Word32

const multiplier = Int32 (Word32 1 << 16)


public func add (a: Fixed32, b: Fixed32) -> Fixed32 {
	return Fixed32 (Int32 a + Int32 b)
}

public func sub (a: Fixed32, b: Fixed32) -> Fixed32 {
	return Fixed32 (Int32 a - Int32 b)
}

public func mul (a: Fixed32, b: Fixed32) -> Fixed32 {
	let a64 = unsafe Int64 a
	let b64 = unsafe Int64 b
	return unsafe Fixed32 (a64 * b64 / Int64 multiplier)
}

public func div (a: Fixed32, b: Fixed32) -> Fixed32 {
	let a64 = unsafe Int64 a
	let b64 = unsafe Int64 b
	return unsafe Fixed32 (a64 * Int64 multiplier / b64)
}

public func fromInt16 (x: Int16) -> Fixed32 {
	return Fixed32 (Int32 x * multiplier)
}

public func toInt16 (x: Fixed32) -> Int16 {
	return unsafe Int16 (Int32 x / multiplier)
}

public func create (a: Int16, b: Int16, c: Int16) -> Fixed32 {
	let tail = div(fromInt16(b), fromInt16(c))
	let head = fromInt16(a)
	return add(head, tail)
}

public func print (x: Fixed32) -> Unit {
	let a = Int32 x / multiplier
	var b = Int32 x % multiplier
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

	printf("%d+%d/%d\n", a, b, c)
}


