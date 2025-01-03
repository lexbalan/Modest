
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
@c_include "math.h"
include "libc/math"
//@attribute("c_no_print")
//import "misc/minmax"
//$pragma c_include "./minmax.h"


const constantArray = [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10]

var globalArray: [10]Int32 = constantArray

var arrayFromString: [3]Char8 = "abc"
//var arrayOfChars = [Char8 "a", 'b', 'c']


func f0(x: [20]Char8) -> [30]Char8 {
	var local_copy_of_x: [20]Char8 = x
	printf("f0(\"%s\")\n", &local_copy_of_x)

	// truncate array
	var mic: [6]Char8 = [6]Char8 x
	mic[5] = "\x0"

	printf("f0 mic = \"%s\"\n", &mic)

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
	var yy: [6]Int32 = startSequence + [] + stopSequence
	var i: Int32 = 0
	while i < lengthof(yy) {
		let y = yy[i]
		printf("yy[%i] = %i\n", i, y)
		i = i + 1
	}
}


public func main() -> Int {
	// generic array [4]Char8 will be implicit casted to [10]Char8

	var em: [30]Char8 = f0("Hello World!")
	printf("em = %s\n", &em)

	var i: Int32 = 0
	while i < 10 {
		let a = globalArray[i]
		printf("globalArray[%i] = %i\n", i, a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var localArray: [3]Int32 = [4, 5, 6]

	i = 0
	while i < 3 {
		let a = localArray[i]
		printf("localArray[%i] = %i\n", i, a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var globalArrayPtr: *[]Int32
	globalArrayPtr = &globalArray

	i = 0
	while i < 3 {
		let a = globalArrayPtr[i]
		printf("globalArrayPtr[%i] = %i\n", i, a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var localArrayPtr: *[]Int32
	localArrayPtr = &localArray

	i = 0
	while i < 3 {
		let a = localArrayPtr[i]
		printf("localArrayPtr[%i] = %i\n", i, a)
		i = i + 1
	}

	// assign array to array 1
	// (with equal types)
	var a: [3]Int32 = [1, 2, 3]
	printf("a[0] = %i\n", a[0])
	printf("a[1] = %i\n", a[1])
	printf("a[2] = %i\n", a[2])

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	var b: [3]Int32 = a
	printf("b[0] = %i\n", b[0])
	printf("b[1] = %i\n", b[1])
	printf("b[2] = %i\n", b[2])

	// check equality between two arrays (by value)
	if a == b {
		printf("a == b\n")
	} else {
		printf("a != b\n")
	}

	// assign array to array 2
	// (with array extending)
	var c: [3]Int32 = [10, 20, 30]
	var d: [6]Int32 = [6]Int32 c
	printf("d[0] = %i\n", d[0])
	printf("d[1] = %i\n", d[1])
	printf("d[2] = %i\n", d[2])
	printf("d[3] = %i\n", d[3])
	printf("d[4] = %i\n", d[4])
	printf("d[5] = %i\n", d[5])


	// check equality between two arrays (by pointer)
	let pa = &a
	let pb = &b

	if *pa == *pb {
		printf("*pa == *pb\n")
	} else {
		printf("*pa != *pb\n")
	}


	//
	// Check assination local literal array
	//


	//let aa = [111] + [222] + [333]
	// cons literal array from var items
	var int100: Int = 100
	var int200: Int = 200
	var int300: Int = 300
	// immutable, non immediate value (array)
	let init_array = [int100, int200, int300]

	// check local literal array assignation to local array
	var e: [4]Int32
	e = init_array
	printf("e[0] = %i\n", e[0])
	printf("e[1] = %i\n", e[1])
	printf("e[2] = %i\n", e[2])

	// check local literal array assignation to global array
	globalArray = init_array
	printf("globalArray[%i] = %i\n", Int32 0, globalArray[0])
	printf("globalArray[%i] = %i\n", Int32 1, globalArray[1])
	printf("globalArray[%i] = %i\n", Int32 2, globalArray[2])


	globalArray = []  // right size = 40


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

	printf("y[%i] = %i (must be 10)\n", Int32 0, y[0])
	printf("y[%i] = %i (must be 20)\n", Int32 1, y[1])
	printf("y[%i] = %i (must be 30)\n", Int32 2, y[2])
	printf("y[%i] = %i (must be 40)\n", Int32 3, y[3])

	if y == [10, 20, 30, 40] {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}


	let sa = [5]Char8 ["L", "o", "H", "i", "!"]

	if sa[2:4] == "Hi" {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

