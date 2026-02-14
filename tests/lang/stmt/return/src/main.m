// test: return statement

func returnInt () -> Int32 {
	return 42
}

func returnBool () -> Bool {
	return true
}

func returnFloat () -> Float64 {
	return 3.14
}

func returnUnit () -> {} {
	return {}
}

func returnRecord () -> {x: Int32, y: Int32} {
	return {x = 1, y = 2}
}

func earlyReturn (x: Int32) -> Int32 {
	if x < 0 {
		return -1
	}
	return x
}

func returnExpr (a: Int32, b: Int32) -> Int32 {
	return a * b + 1
}

func returnFromWhile () -> Int32 {
	var i: Int32 = 0
	while i < 100 {
		if i == 42 {
			return i
		}
		i = i + 1
	}
	return -1
}

public func main () -> Int32 {
	var a = returnInt()
	var b = returnBool()
	var c = returnFloat()
	var d = returnUnit()
	var e = returnRecord()
	var f = earlyReturn(-5)
	var g = returnExpr(3, 4)
	var h = returnFromWhile()
	return 0
}
