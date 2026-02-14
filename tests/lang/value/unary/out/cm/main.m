

func testNeg () -> Int32 {
	var x: Int32 = 5
	return -x
}

func testIncrement () -> Int32 {
	var x: Int32 = 0
	x = x + 1
	x = x + 1
	x = x + 1
	return x
}

func testDecrement () -> Int32 {
	var x: Int32 = 10
	x = x - 1
	x = x - 1
	return x
}

func testAddressOf () -> *Int32 {
	var x: Int32 = 42
	return &x
}

func testDeref () -> Int32 {
	var x: Int32 = 42
	var p: *Int32 = &x
	return *p
}

func testNotBool () -> Bool {
	var x: Bool = true
	return not x
}

public func main () -> Int32 {
	var a: Int32 = testNeg()
	var b: Int32 = testIncrement()
	var c: Int32 = testDecrement()
	var d: *Int32 = testAddressOf()
	var e: Int32 = testDeref()
	var f: Bool = testNotBool()
	return 0
}

