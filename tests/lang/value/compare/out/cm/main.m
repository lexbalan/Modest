private import "builtin"


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

public func main () -> Int32 {
	var a: Bool = testEq()
	var b: Bool = testNeq()
	var c: Bool = testLt()
	var d: Bool = testLe()
	var e: Bool = testGt()
	var f: Bool = testGe()
	var g: Bool = compareVars(1, 2)
	var h: Bool = compareFloat(1.0, 2.0)
	return 0
}

