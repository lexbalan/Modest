include "ctypes64"
include "stdio"



func array_print (pa: *[]Int32, len: Nat32) -> Unit {
	var i: Nat32 = 0
	while i < len {
		printf("a[%d] = %d\n", Nat32 i, Int32 pa[i])
		i = i + 1
	}
}


public func main () -> Int {
	printf("test slices\n")

	//
	// by value
	//

	var a: [10]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	let s1: [2 - 1]Int32 = a[1:2]
	var i: Nat32 = 0
	while i < lengthof(s1) {
		printf("s1[%d] = %d\n", Nat32 i, Int32 s1[i])
		i = i + 1
	}

	printf("--------------------------------------------\n")

	//
	// by ptr
	//

	let pa: *[10]Int32 = &a
	let s2: [8 - 5]Int32 = pa[5:8]
	i = 0
	while i < lengthof(s2) {
		printf("s2[%d] = %d\n", Nat32 i, Int32 s2[i])
		i = i + 1
	}

	printf("--------------------------------------------\n")

	var vs1: [2 - 1]Int32 = s1
	var vs2: [8 - 5]Int32 = s2

	let ax = 2
	let bx = 6
	a[ax:bx] = [10, 20, 30, 40]

	i = 0
	while i < lengthof(a) {
		printf("a[%d] = %d\n", Nat32 i, Int32 a[i])
		i = i + 1
	}

	printf("--------------------------------------------\n")

	var s = [10]Int32 [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

	s[2:5] = []

	i = 0
	while i < lengthof(s) {
		printf("s[%d] = %d\n", Nat32 i, Nat32 Nat32 s[i])
		i = i + 1
	}

	printf("--------------------------------------------\n")
	printf("test pointer to slice\n")

	let aa = 2
	let bb = 8

	let p: *[bb - aa]Int32 = &s[aa:bb]
	array_print(p, lengthof(*p))

	printf("--------------------------------------------\n")

	p[0] = 123

	array_print(p, lengthof(*p))

	printf("--------------------------------------------\n")
	printf("slice of pointer to open array\n")

	// за каким то хером это работает, то что мне сейчас нужно
	// но тут еще куча работы впереди

	var pw = *[]Int32 &s

	printf("before\n")
	array_print(pw, 10)

	var ind: Int32 = 1

	pw = &pw[ind:]

	printf("after\n")
	array_print(pw, 10)

	printf("--------------------------------------------\n")
	printf("zero slice by var\n")
	// NOT WORKED NOW

	var ss = [10]Int32 [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	var k: Int32 = 4
	var j: Int32 = 7
	ss[k:j] = []
	array_print(&ss, 10)

	printf("--------------------------------------------\n")
	printf("copy slice by var\n")

	var src = [5]Int32 [10, 20, 30, 40, 50]
	var dst = [10]Int32 [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	// test with let
	let i1 = 3
	let j1 = 8
	dst[i1:j1] = [11, 22, 33, 44, 55]

	array_print(&dst, 10)

	//	printf("--------------------------------------------\n")
	//
	//	var dst2 = []Int32 [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]
	//
	//	var axx = Nat8 111
	//	var bxx = Nat8 222
	//
	//	// FIXIT: test with var
	//	// ARRCPY не умеет копировать generic массив, исправь это
	//	var i2: Int32 = 3
	//	var j2: Int32 = 5
	//	dst2[i2:j2] = [Int32 axx, Int32 bxx]
	//
	//	array_print(&dst2, 10)

	return 0
}

