private import "builtin"


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
	var c: Int32 = a + b
	var d: Int32 = a - b
	var e: Int32 = a * b
	var f: Int32 = a / b
	var g: Int32 = a % b
	return c + d + e + f + g
}

func testFloatArith () -> Float64 {
	var a: Float64 = 1.5
	var b: Float64 = 2.5
	var c: Float64 = 2.0
	return a + b * c
}

func main () -> Int32 {
	var a: Int32 = testAdd()
	var b: Int32 = testSub()
	var c: Int32 = testMul()
	var d: Int32 = testDiv()
	var e: Int32 = testMod()
	var f: Int32 = testComplex()
	var g: Int32 = testPrecedence()
	var h: Int32 = testNeg()
	var i: Int32 = testVarArith()
	var j: Float64 = testFloatArith()
	return 0
}

