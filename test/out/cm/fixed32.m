include "stdio"



public type Fixed32 = Word32


const base = 65536
public func create (a: Int16, b: Nat16, c: Nat16) -> Fixed32 {
	let ntail: Nat32 = Nat32 b * base / Nat32 c
	return Fixed32 (Word32 (Int32 a * base) or Word32 ntail)
}


func head (x: Fixed32) -> Int16 {
	return Int16 (x >> 16)
}


func tail (x: Fixed32) -> Nat16 {
	return Nat16 ((Word32 x) and (base - 1))
}


public func print (x: Fixed32) -> Unit {
	let a: Int16 = head(x)
	var b = Nat32 tail(x)
	var c: Nat32 = base

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


public func add (a: Fixed32, b: Fixed32) -> Fixed32 {
	return Fixed32 (Int32 a + Int32 b)
}


public func sub (a: Fixed32, b: Fixed32) -> Fixed32 {
	return Fixed32 (Int32 a - Int32 b)
}


public func mul (a: Fixed32, b: Fixed32) -> Fixed32 {
	let ax = Int64 a
	let bx = Int64 b
	let cx: Int64 = ax * bx / base
	return Fixed32 cx
}


public func div (a: Fixed32, b: Fixed32) -> Fixed32 {
	let ax = Int64 a
	let bx = Int64 b
	let cx: Int64 = ax * base / bx
	return Fixed32 cx
}


public func trunc (x: Fixed32) -> Fixed32 {
	return Fixed32 (Word32 x and 0xFFFF0000)
}


public func fract (x: Fixed32) -> Fixed32 {
	return Fixed32 (Word32 x and 0x0000FFFF)
}
public func floor (x: Fixed32) -> Fixed32 {
	var y: Int16 = head(x)
	return create(y, 0, 1)
}
public func ceil (x: Fixed32) -> Fixed32 {
	var y: Int16 = head(x)
	if tail(x) > 0 {
		y = y + 1
	}
	return create(y, 0, 1)
}

