// test: array types

type Vec3 = [3]Float32
type Matrix2x2 = [2][2]Int32

var fixed: [5]Int32
var inited: [5]Int32 = [1, 2, 3, 4, 5]

func sumFixedArray (arr: *[5]Int32, len: Nat32) -> Int32 {
	var s: Int32 = 0
	var i: Nat32 = 0
	while i < len {
		s = s + (*arr)[i]
		i = i + 1
	}
	return s
}

func fillArray (arr: *[5]Int32) -> Unit {
	var i: Nat32 = 0
	while i < 5 {
		(*arr)[i] = Int32 i
		i = i + 1
	}
}

func testMultidim () -> Int32 {
	var m: [2][3]Int32
	m[0][0] = 1
	m[0][1] = 2
	m[0][2] = 3
	m[1][0] = 4
	m[1][1] = 5
	m[1][2] = 6
	return m[1][2]
}

public func main () -> Int32 {
	var v: Vec3
	v[0] = 1.0
	v[1] = 2.0
	v[2] = 3.0
	fillArray(&fixed)
	var s = sumFixedArray(&inited, 5)
	var x = testMultidim()
	return 0
}
