private import "builtin"


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
	var a: Bool = true
	var b: Bool = false
	var c: Bool = true
	return (a and b) or (not b and c)
}

func testWithCompare () -> Bool {
	var x: Int32 = 5
	return x > 0 and x < 10
}

func testNested () -> Bool {
	var a: Bool = true
	var b: Bool = true
	var c: Bool = false
	return not (a and b) or c
}

func main () -> Int32 {
	var a: Bool = testAnd()
	var b: Bool = testOr()
	var c: Bool = testNot()
	var d: Bool = testComplex()
	var e: Bool = testWithCompare()
	var f: Bool = testNested()
	return 0
}

