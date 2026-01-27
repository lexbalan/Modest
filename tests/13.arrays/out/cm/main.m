include "ctypes64"
include "stdio"
include "math"



// Что можно делать с массивом
//   1.1 Создать без инициализации
//   1.2 Создать и проинициализировать пустым литералом
//   1.3 Создать и проинициализировать generic литералом
//   1.4 Создать и проинициализировать non-generic литералом
//
//   2.1 Присвоить массив массиву (константу, переменную)
//   2.2 Передать в функцию
//   2.3 Вернуть из функции
//
//   3.1 Сохранить значение в ячейку массива
//   3.2 Загрузить значение из ячейки массива
//
//   4.1 Загрузить срез (подмассив)
//   4.2 Сохранить срез (подмассив)
//
//   5.1 Получить длину массива (в элементах)
//   5.2 Получить размер массива (в байтах)
//
//   6.1 Создать VLA массив



const constantArray = [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10]

var globalArray: [10]Int32 = constantArray

var arrayFromString: [3]Char8 = "abc"


//var arrayOfChars = [Char8 "a", 'b', 'c']


func f0 (x: [20]Char8) -> [30]Char8 {
	var local_copy_of_x: [20]Char8 = x
	printf("f0(\"%s\")\n", *[20]Char8 &local_copy_of_x)

	// truncate array
	var mic: [6]Char8 = x[0:6]
	mic[5] = "\x0"

	printf("f0 mic = \"%s\"\n", *[6]Char8 &mic)

	// extend array
	var res: [30]Char8
	res[0:20] = x
	res[20:30] = []

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


func test () -> Unit {
	// тестируем работу с локальным generic массивом
	var yy: [6]Word8 = startSequence + [] + stopSequence
	var i: Nat32 = 0
	while i < lengthof(yy) {
		let y: Word8 = yy[i]
		printf("yy[%i] = %u\n", Nat32 i, Word32 Word32 y)
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


func test_arrays () -> Unit {
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
			printf("a10[%d][%d] = %d\n", Int32 i, Int32 j, Int32 a10[i][j])
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
				printf("a3[%d][%d][%d] = %d\n", Int32 i, Int32 j, Int32 k, Int32 a0[i][j][k])
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
			printf("a3[%d][%d] = %d\n", Int32 i, Int32 j, Int32 a3[i][j])
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
				printf("a3[%d][%d][%d] = %d\n", Int32 i, Int32 j, Int32 k, Int32 a4[i][j][k])
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
				printf("p0[%d][%d][%d] = %d\n", Int32 i, Int32 j, Int32 k, Int32 p0[i][j][k])
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}



public func main () -> Int {
	// generic array [4]Char8 will be implicit casted to [10]Char8

	test()

	var em: [30]Char8 = f0("Hello World!")
	printf("em = %s\n", *[30]Char8 &em)

	var i: Nat32 = 0
	while i < 10 {
		let a: Int32 = globalArray[i]
		printf("globalArray[%i] = %i\n", Nat32 i, Int32 a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var localArray: [3]Int32 = [4, 5, 6]

	i = 0
	while i < 3 {
		let a: Int32 = localArray[i]
		printf("localArray[%i] = %i\n", Nat32 i, Int32 a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var globalArrayPtr: *[]Int32
	globalArrayPtr = &globalArray

	i = 0
	while i < 3 {
		let a: Int32 = globalArrayPtr[i]
		printf("globalArrayPtr[%i] = %i\n", Nat32 i, Int32 a)
		i = i + 1
	}

	printf("------------------------------------\n")

	var localArrayPtr: *[]Int32
	localArrayPtr = &localArray

	i = 0
	while i < 3 {
		let a: Int32 = localArrayPtr[i]
		printf("localArrayPtr[%i] = %i\n", Nat32 i, Int32 a)
		i = i + 1
	}

	// assign array to array 1
	// (with equal types)
	var a: [3]Int32 = [1, 2, 3]
	printf("a[0] = %i\n", Int32 a[0])
	printf("a[1] = %i\n", Int32 a[1])
	printf("a[2] = %i\n", Int32 a[2])

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	var b: [3]Int32 = a
	printf("b[0] = %i\n", Int32 b[0])
	printf("b[1] = %i\n", Int32 b[1])
	printf("b[2] = %i\n", Int32 b[2])

	// check equality between two arrays (by value)
	if a == b {
		printf("a == b\n")
	} else {
		printf("a != b\n")
	}

	// assign array to array 2
	// (with array extending)
	var c: [3]Int32 = [10, 20, 30]

	var d: [6]Int32
	d[0:3] = c
	d[3:6] = []

	printf("d[0] = %i\n", Int32 d[0])
	printf("d[1] = %i\n", Int32 d[1])
	printf("d[2] = %i\n", Int32 d[2])
	printf("d[3] = %i\n", Int32 d[3])
	printf("d[4] = %i\n", Int32 d[4])
	printf("d[5] = %i\n", Int32 d[5])

	// check equality between two arrays (by pointer)
	let pa: *[3]Int32 = &a
	let pb: *[3]Int32 = &b

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
	e = [4]Int32 init_array
	printf("e[0] = %i\n", Int32 e[0])
	printf("e[1] = %i\n", Int32 e[1])
	printf("e[2] = %i\n", Int32 e[2])

	// check local literal array assignation to global array
	globalArray = [10]Int32 init_array
	printf("globalArray[%i] = %i\n", Int32 Int32 0, Int32 globalArray[0])
	printf("globalArray[%i] = %i\n", Int32 Int32 1, Int32 globalArray[1])
	printf("globalArray[%i] = %i\n", Int32 Int32 2, Int32 globalArray[2])


	globalArray = []


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	var ax = Int32 10
	var bx = Int32 20
	var cx = Int32 30
	let dx = Int32 40

	let y = [ax, bx, cx, dx]

	ax = 111
	bx = 222
	cx = 333

	printf("y[%i] = %i (must be 10)\n", Int32 Int32 0, Int32 y[0])
	printf("y[%i] = %i (must be 20)\n", Int32 Int32 1, Int32 y[1])
	printf("y[%i] = %i (must be 30)\n", Int32 Int32 2, Int32 y[2])
	printf("y[%i] = %i (must be 40)\n", Int32 Int32 3, Int32 y[3])

	if y == [10, 20, 30, 40] {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}


	// BUG: НЕ РАБОТАЕТ!
	//	let sa = []Char8 ['L', 'o', 'H', 'i', '!']
	//
	//	if sa[2:4] == "Hi" {
	//		printf("test passed\n")
	//	} else {
	//		printf("test failed\n")
	//	}

	test_arrays()


	// not immediate local array literal test
	var va: Int32 = 5
	var vb = Int32 7
	var varr = [4]Int32 [1, 2, va, vb]

	return 0
}

