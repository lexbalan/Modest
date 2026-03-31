import "builtin"


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
	var a: Int32 = returnInt()
	var b: Bool = returnBool()
	var c: Float64 = returnFloat()
	var e: {x: Int32, y: Int32} = returnRecord()
	var f: Int32 = earlyReturn(-5)
	var g: Int32 = returnExpr(3, 4)
	var h: Int32 = returnFromWhile()
	return 0
}

