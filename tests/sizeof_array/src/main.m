include "libc/stdio"
include "libc/stdlib"
include "libc/string"


var a0 = []Int32 [0, 1, 2, 3, 4, 5]
var a1 = [][]Int32 [[0, 1, 2, 3, 4, 5], [0, 1, 2, 3, 4, 5]]
var a2 = [][]Int32 [
	[0, 1, 2, 3, 4, 5]
	[0, 1, 2, 3, 4, 5]
	[0, 1, 2, 3, 4, 5]
]
var a3 = [][][]Int32 [
	[
		[0, 1, 2, 3, 4, 5]
		[0, 1, 2, 3, 4, 5]
	]
	[
		[0, 1, 2, 3, 4, 5]
		[0, 1, 2, 3, 4, 5]
	]
]

var data: [][]*Str8 = [
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
	["4", "Xerox",   "Yep",     "Zn"]
]


// ERROR: здесь пытаемся создать массив массивов массивов чаров
// а получаем массив массивов указателей на чар TODO
var data2: [][]Str8 = [
	["0", "Alef",    "Betha",   "Emma"]
	["1", "Clock",   "Depth",   "Free"]
	["2", "Ink",     "Julia",   "Keyword"]
	["3", "Ultra",   "Video",   "Word"]
	["4", "Xerox",   "Yep",     "Zn"]
]


public func main() -> Int32 {
	printf("lengthof(a0) = %lu\n", lengthof(a0))
	printf("sizeof(a0) = %lu\n", sizeof(a0))

	//printf("lengthof(a0[0]) = %lu\n", lengthof(a0[0]))
	printf("sizeof(a0[0]) = %lu\n", sizeof(a0[0]))

	printf("\n")

	printf("lengthof(a1) = %lu\n", lengthof(a1))
	printf("sizeof(a1) = %lu\n", sizeof(a1))

	printf("lengthof(a1[0]) = %lu\n", lengthof(a1[0]))
	printf("sizeof(a1[0]) = %lu\n", sizeof(a1[0]))
	printf("sizeof(a1[0][0]) = %lu\n", sizeof(a1[0][0]))

	printf("\n")

	printf("lengthof(a2) = %lu\n", lengthof(a2))
	printf("sizeof(a2) = %lu\n", sizeof(a2))

	printf("\n")

	printf("lengthof(a3) = %lu\n", lengthof(a3))
	printf("lengthof(a3[0]) = %lu\n", lengthof(a3[0]))
	printf("lengthof(a3[0][0]) = %lu\n", lengthof(a3[0][0]))
	printf("sizeof(a3) = %lu\n", sizeof(a3))

	//
	printf("\n")

	printf("sizeof(data) = %lu\n", sizeof(data))
	printf("sizeof(data[0]) = %lu\n", sizeof(data[0]))
	printf("lengthof(data) = %lu\n", lengthof(data))
	printf("lengthof(data[0]) = %lu\n", lengthof(data[0]))

	printf("\n")

	printf("sizeof(data2) = %lu\n", sizeof(data2))
	printf("sizeof(data2[0]) = %lu\n", sizeof(data2[0]))
	printf("lengthof(data2) = %lu\n", lengthof(data2))
	printf("lengthof(data2[0]) = %lu\n", lengthof(data2[0]))

	//print2DArray(&data, 5, 4)
	return 0
}


