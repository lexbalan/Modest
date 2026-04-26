// tests/lang/value/unary/src/main.m

func testNeg () -> Int32 {
	var x: Int32 = 5
	return -x
}

func testIncrement () -> Int32 {
	var x: Int32 = 0
	++x
	++x
	++x
	return x
}

func testDecrement () -> Int32 {
	var x: Int32 = 10
	--x
	--x
	return x
}

func testAddressOf () -> *Int32 {
	var x: Int32 = 42
	return &x
}

func testDeref () -> Int32 {
	var x: Int32 = 42
	var p = &x
	return *p
}

func testNotBool () -> Bool {
	var x = true
	return not x
}

func main () -> Int32 {
	var a = testNeg()
	var b = testIncrement()
	var c = testDecrement()
	var d = testAddressOf()
	var e = testDeref()
	var f = testNotBool()
	return 0
}
