private import "builtin"


func abs (x: Int32) -> Int32 {
	if x < 0 {
		return -x
	}
	return x
}

func clamp (x: Int32, lo: Int32, hi: Int32) -> Int32 {
	if x < lo {
		return lo
	} else if x > hi {
		return hi
	}

	return x
}

func sign (x: Int32) -> Int32 {
	if x > 0 {
		return 1
	} else if x < 0 {
		return -1
	}
	return 0
}

func testNested () -> Int32 {
	var x: Int32 = 10
	if x > 0 {
		if x > 5 {
			if x > 8 {
				return 3
			}
			return 2
		}
		return 1
	}
	return 0
}

public func main () -> Int32 {
	var a: Int32 = abs(-5)
	var b: Int32 = clamp(15, 0, 10)
	var c: Int32 = sign(-3)
	var d: Int32 = testNested()
	return 0
}

