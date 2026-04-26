// tests/lang/value/compare/src/main.m

func testEq () -> Bool {
	return 1 == 1
}

func testNeq () -> Bool {
	return 1 != 2
}

func testLt () -> Bool {
	return 1 < 2
}

func testLe () -> Bool {
	return 1 <= 1
}

func testGt () -> Bool {
	return 2 > 1
}

func testGe () -> Bool {
	return 1 >= 1
}

func compareVars (a: Int32, b: Int32) -> Bool {
	if a == b {
		return true
	}
	if a < b {
		return false
	}
	return true
}

func compareFloat (a: Float64, b: Float64) -> Bool {
	return a < b
}

func main () -> Int32 {
	var a = testEq()
	var b = testNeq()
	var c = testLt()
	var d = testLe()
	var e = testGt()
	var f = testGe()
	var g = compareVars(1, 2)
	var h = compareFloat(1.0, 2.0)
	return 0
}
