// test: array index expressions

var arr = [10, 20, 30, 40, 50]

func readIndex () -> Int32 {
	return arr[0]
}

func writeIndex () -> {} {
	arr[0] = 99
}

func indexWithVar () -> Int32 {
	var i: Nat32 = 2
	return arr[i]
}

func indexExpr () -> Int32 {
	var i: Nat32 = 1
	return arr[i + 1]
}

func localArray () -> Int32 {
	var local = [5, 10, 15]
	return local[1]
}

func multiDim () -> Int32 {
	var m: [2][3]Int32
	m[0][0] = 1
	m[1][2] = 6
	return m[1][2]
}

public func main () -> Int32 {
	var a = readIndex()
	writeIndex()
	var b = indexWithVar()
	var c = indexExpr()
	var d = localArray()
	var e = multiDim()
	return 0
}
