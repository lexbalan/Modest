
@c_include "stdio.h"
@c_include "math.h"

//@attribute("c_no_print")
//import "misc/minmax"
//$pragma c_include "./minmax.h"


const constantArray = [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10]

var globalArray: [10]Int32 = constantArray

var arrayFromString: [3]Char8 = "abc"


//var arrayOfChars = [Char8 "a", 'b', 'c']


func f0(x: [20]Char8) -> [30]Char8 {
	var local_copy_of_x: [20]Char8 = x
	stdio.printf("f0(\"%s\")\n", &local_copy_of_x)

	// truncate array
	var mic: [6]Char8 = [6]Char8 x
	mic[5] = "\x0"

	stdio.printf("f0 mic = \"%s\"\n", &mic)

	// extend array
	var res: [30]Char8 = [30]Char8 x
	res[6] = "M"
	res[7] = "o"
	res[8] = "d"
	res[9] = "e"
	res[10] = "s"
	res[11] = "t"
	res[12] = "!"
	res[13] = "\x0"
	return res
}


const startSequence = [0xAA, 0x55, 0x02]
const stopSequence = [0x16]


func test() -> Unit {
	// тестируем работу с локальным generic массивом
	var yy: [6]Word64 = startSequence + [] + stopSequence
	var i: Int32 = 0
	while i < lengthof(yy) {
		let y = yy[i]
		stdio.printf("yy[%i] = %i\n", i, y)
		i = i + 1
	}
}







var a0: [2][2][5]Int32 = [
	[
		[0, 1, 2, 3, 4]
		[5, 6, 7, 8, 9]
	]
	[
		[10, 11, 12, 13, 14]
		[15, 16, 17, 18, 19]
	]
]

var a1: [5]Int32 = [0, 1, 2, 3, 4]
var a2: [5]Int32 = [5, 6, 7, 8, 9]
var a3: [2]*[5]Int32 = [&a1, &a2]
var a4: [2]*[2]*[5]Int32 = [&a3, &a3]
var p0: *[2]*[2]*[5]Int32 = &a4


var a10: [10][10]Int32 = [
	[01, 02, 03, 04, 05, 06, 07, 08, 09, 10]
	[11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
	[21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
	[31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
	[41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
	[51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
	[61, 62, 63, 64, 65, 66, 67, 68, 69, 70]
	[71, 72, 73, 74, 75, 76, 77, 78, 79, 80]
	[81, 82, 83, 84, 85, 86, 87, 88, 89, 90]
	[91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
]


func test_arrays() -> Unit {
	var i: Int32
	var j: Int32
	var k: Int32

	i = 0
	while i < 10 {
		j = 0
		while j < 10 {
			a10[i][j] = a10[i][j] * 2
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < 10 {
		j = 0
		while j < 10 {
			stdio.printf("a10[%d][%d] = %d\n", i, j, a10[i][j])
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < 2 {
		j = 0
		while j < 2 {
			k = 0
			while k < 5 {
				stdio.printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i][j][k])
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
	//
	//
	i = 0
	while i < 2 {
		j = 0
		while j < 5 {
			stdio.printf("a3[%d][%d] = %d\n", i, j, a3[i][j])
			j = j + 1
		}
		i = i + 1
	}
	//
	//
	i = 0
	while i < 2 {
		j = 0
		while j < 2 {
			k = 0
			while k < 5 {
				stdio.printf("a3[%d][%d][%d] = %d\n", i, j, k, a4[i][j][k])
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}

	i = 0
	while i < 2 {
		j = 0
		while j < 2 {
			k = 0
			while k < 5 {
				stdio.printf("p0[%d][%d][%d] = %d\n", i, j, k, p0[i][j][k])
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}





public func main() -> ctypes64.Int {
	// generic array [4]Char8 will be implicit casted to [10]Char8

	var em: [30]Char8 = f0("Hello World!")
	stdio.printf("em = %s\n", &em)

	var i: Int32 = 0
	while i < 10 {
		let a = globalArray[i]
		stdio.printf("globalArray[%i] = %i\n", i, a)
		i = i + 1
	}

	stdio.printf("------------------------------------\n")

	var localArray: [3]Int32 = [4, 5, 6]

	i = 0
	while i < 3 {
		let a = localArray[i]
		stdio.printf("localArray[%i] = %i\n", i, a)
		i = i + 1
	}

	stdio.printf("------------------------------------\n")

	var globalArrayPtr: *[]Int32
	globalArrayPtr = &globalArray

	i = 0
	while i < 3 {
		let a = globalArrayPtr[i]
		stdio.printf("globalArrayPtr[%i] = %i\n", i, a)
		i = i + 1
	}

	stdio.printf("------------------------------------\n")

	var localArrayPtr: *[]Int32
	localArrayPtr = &localArray

	i = 0
	while i < 3 {
		let a = localArrayPtr[i]
		stdio.printf("localArrayPtr[%i] = %i\n", i, a)
		i = i + 1
	}

	// assign array to array 1
	// (with equal types)
	var a: [3]Int32 = [1, 2, 3]
	stdio.printf("a[0] = %i\n", a[0])
	stdio.printf("a[1] = %i\n", a[1])
	stdio.printf("a[2] = %i\n", a[2])

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	var b: [3]Int32 = a
	stdio.printf("b[0] = %i\n", b[0])
	stdio.printf("b[1] = %i\n", b[1])
	stdio.printf("b[2] = %i\n", b[2])

	// check equality between two arrays (by value)
	if a == b {
		stdio.printf("a == b\n")
	} else {
		stdio.printf("a != b\n")
	}

	// assign array to array 2
	// (with array extending)
	var c: [3]Int32 = [10, 20, 30]
	var d: [6]Int32 = [6]Int32 c
	stdio.printf("d[0] = %i\n", d[0])
	stdio.printf("d[1] = %i\n", d[1])
	stdio.printf("d[2] = %i\n", d[2])
	stdio.printf("d[3] = %i\n", d[3])
	stdio.printf("d[4] = %i\n", d[4])
	stdio.printf("d[5] = %i\n", d[5])


	// check equality between two arrays (by pointer)
	let pa = &a
	let pb = &b

	if *pa == *pb {
		stdio.printf("*pa == *pb\n")
	} else {
		stdio.printf("*pa != *pb\n")
	}


	//
	// Check assination local literal array
	//


	//let aa = [111] + [222] + [333]
	// cons literal array from var items
	var int100: ctypes64.Int = 100
	var int200: ctypes64.Int = 200
	var int300: ctypes64.Int = 300
	// immutable, non immediate value (array)
	let init_array = [int100, int200, int300]

	// check local literal array assignation to local array
	var e: [4]Int32
	e = init_array
	stdio.printf("e[0] = %i\n", e[0])
	stdio.printf("e[1] = %i\n", e[1])
	stdio.printf("e[2] = %i\n", e[2])

	// check local literal array assignation to global array
	globalArray = init_array
	stdio.printf("globalArray[%i] = %i\n", Int32 0, globalArray[0])
	stdio.printf("globalArray[%i] = %i\n", Int32 1, globalArray[1])
	stdio.printf("globalArray[%i] = %i\n", Int32 2, globalArray[2])


	globalArray = []


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	var ax: Int32 = Int32 10
	var bx: Int32 = Int32 20
	var cx: Int32 = Int32 30
	let dx = Int32 40

	let y = [ax, bx, cx, dx]

	ax = 111
	bx = 222
	cx = 333

	stdio.printf("y[%i] = %i (must be 10)\n", Int32 0, y[0])
	stdio.printf("y[%i] = %i (must be 20)\n", Int32 1, y[1])
	stdio.printf("y[%i] = %i (must be 30)\n", Int32 2, y[2])
	stdio.printf("y[%i] = %i (must be 40)\n", Int32 3, y[3])

	if y == [10, 20, 30, 40] {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}


	let sa = [5]Char8 ["L", "o", "H", "i", "!"]

	if sa[2:4] == "Hi" {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}

	test_arrays()

	return 0
}

