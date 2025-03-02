
@c_include "stdio.h"


func array_print(pa: *[]Int32, len: Int32) -> Unit {
	var i: Int32 = 0
	while i < len {
		stdio.printf("a[%d] = %d\n", i, pa[i])
		i = i + 1
	}
}


public func main() -> ctypes64.Int {
	stdio.printf("test slices\n")

	//
	// by value
	//

	var a: [10]Int32 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	let s1 = a[1:2]
	var i: Int32 = 0
	while i < lengthof(s1) {
		stdio.printf("s1[%d] = %d\n", i, s1[i])
		i = i + 1
	}

	stdio.printf("--------------------------------------------\n")

	//
	// by ptr
	//

	let pa = &a
	let s2 = pa[5:8]
	i = 0
	while i < lengthof(s2) {
		stdio.printf("s2[%d] = %d\n", i, s2[i])
		i = i + 1
	}

	stdio.printf("--------------------------------------------\n")

	var vs1: [2 - 1]Int32 = s1
	var vs2: [8 - 5]Int32 = s2

	let ax = 2
	let bx = 6
	a[ax:bx] = [10, 20, 30, 40]

	i = 0
	while i < lengthof(a) {
		stdio.printf("a[%d] = %d\n", i, a[i])
		i = i + 1
	}

	stdio.printf("--------------------------------------------\n")

	var s: [10]Int32 = [10]Int32 [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

	s[2:5] = []

	i = 0
	while i < lengthof(s) {
		stdio.printf("s[%d] = %d\n", i, Nat32 s[i])
		i = i + 1
	}

	stdio.printf("--------------------------------------------\n")
	stdio.printf("test pointer to slice\n")

	let aa = 2
	let bb = 8

	let p = &s[aa:bb]
	array_print(p, lengthof(*p))

	stdio.printf("--------------------------------------------\n")

	p[0] = 123

	array_print(p, lengthof(*p))

	stdio.printf("--------------------------------------------\n")
	stdio.printf("slice of pointer to open array\n")

	// за каким то хером это работает, то что мне сейчас нужно
	// но тут еще куча работы впереди

	var pw: *[]Int32 = *[]Int32 &s

	stdio.printf("before\n")
	array_print(pw, 10)

	var ind: Int32 = 1

	pw = &pw[ind:]

	stdio.printf("after\n")
	array_print(pw, 10)

	stdio.printf("--------------------------------------------\n")
	stdio.printf("zero slice by var\n")
	// NOT WORKED NOW

	var ss: [10]Int32 = [10]Int32 [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	var k: Int32 = 4
	var j: Int32 = 7
	ss[k:j] = []
	array_print(&ss, 10)

	stdio.printf("--------------------------------------------\n")
	stdio.printf("copy slice by var\n")

	var src: [5]Int32 = [5]Int32 [10, 20, 30, 40, 50]
	var dst: [10]Int32 = [10]Int32 [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

	// test with let
	let i1 = 3
	let j1 = 8
	dst[i1:j1] = [11, 22, 33, 44, 55]

	array_print(&dst, 10)

	stdio.printf("--------------------------------------------\n")

	var dst2: [10]Int32 = [10]Int32 [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]

	var axx: Nat8 = Nat8 111
	var bxx: Nat8 = Nat8 222

	// test with var
	var i2: Int32 = 3
	var j2: Int32 = 5
	dst2[i2:j2] = [Int32 axx, Int32 bxx]

	array_print(&dst2, 10)

	return 0
}

