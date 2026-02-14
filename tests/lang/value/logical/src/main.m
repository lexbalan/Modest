// test: logical expressions

func testAnd () -> Bool {
	return true and true
}

func testOr () -> Bool {
	return false or true
}

func testNot () -> Bool {
	return not false
}

func testComplex () -> Bool {
	var a = true
	var b = false
	var c = true
	return (a and b) or (not b and c)
}

func testWithCompare () -> Bool {
	var x: Int32 = 5
	return x > 0 and x < 10
}

func testNested () -> Bool {
	var a = true
	var b = true
	var c = false
	return not (a and b) or c
}

public func main () -> Int32 {
	var a = testAnd()
	var b = testOr()
	var c = testNot()
	var d = testComplex()
	var e = testWithCompare()
	var f = testNested()
	return 0
}
