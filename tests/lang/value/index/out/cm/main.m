import "builtin"


var arr: [5]Int32 = [10, 20, 30, 40, 50]

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
	var local: [3]Int32 = [5, 10, 15]
	return local[1]
}

func multiDim () -> Int32 {
	var m: [2][3]Int32
	m[0][0] = 1
	m[1][2] = 6
	return m[1][2]
}

public func main () -> Int32 {
	var a: Int32 = readIndex()
	writeIndex()
	var b: Int32 = indexWithVar()
	var c: Int32 = indexExpr()
	var d: Int32 = localArray()
	var e: Int32 = multiDim()
	return 0
}

