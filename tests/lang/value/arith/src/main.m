// test: arithmetic expressions

func testAdd () -> Int32 {
	return 1 + 2
}

func testSub () -> Int32 {
	return 10 - 3
}

func testMul () -> Int32 {
	return 4 * 5
}

func testDiv () -> Int32 {
	return 20 / 4
}

func testMod () -> Int32 {
	return 17 % 5
}

func testComplex () -> Int32 {
	return (1 + 2) * (3 + 4)
}

func testPrecedence () -> Int32 {
	return 2 + 3 * 4
}

func testNeg () -> Int32 {
	var x: Int32 = 5
	return 0 - x
}

func testVarArith () -> Int32 {
	var a: Int32 = 10
	var b: Int32 = 3
	var c = a + b
	var d = a - b
	var e = a * b
	var f = a / b
	var g = a % b
	return c + d + e + f + g
}

func testFloatArith () -> Float64 {
	var a: Float64 = 1.5
	var b: Float64 = 2.5
	var c: Float64 = 2.0
	return a + b * c
}

public func main () -> Int32 {
	var a = testAdd()
	var b = testSub()
	var c = testMul()
	var d = testDiv()
	var e = testMod()
	var f = testComplex()
	var g = testPrecedence()
	var h = testNeg()
	var i = testVarArith()
	var j = testFloatArith()
	return 0
}
