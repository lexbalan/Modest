// test: if statement

func abs (x: Int32) -> Int32 {
	if x < 0 {
		return -x
	}
	return x
}

func clamp (x: Int32, lo: Int32, hi: Int32) -> Int32 {
	if x < lo {
		return lo
	} else {
		if x > hi {
			return hi
		} else {
			return x
		}
	}
}

func sign (x: Int32) -> Int32 {
	if x > 0 {
		return 1
	} else {
		if x < 0 {
			return -1
		} else {
			return 0
		}
	}
}

func testNested () -> Int32 {
	var x = 10
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
	var a = abs(-5)
	var b = clamp(15, 0, 10)
	var c = sign(-3)
	var d = testNested()
	return 0
}
