// test/pre/src/main.cm

//import "libc/stdio"


$pragma c_include "stdio.h"

@attribute("c-no-print")
export func printf(s: *Str8, ...)


var x: Int


func main() -> Int {
	printf("test\n")

	printf("subName = '%s'\n", *Str8 subName)
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	var y = default

	let a = 10
	let b = 20
	let s = mid(a, b)
	printf("s = %d\n", s)

	var xx: Int

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12

	return 0
}

let default = 5


let subName = "Name"


@property("value.id.c", "arrshow")
@property("value.id.cm", "arrshow")
func arrayShow(array: *Arr, size: Int) -> Unit {
	printf("arrayShow:\n")
	var i = 0
	while i < 10 {
		printf("array[%d] = %d\n", i, array[i])
		++i
	}
}

@property("type.id.c", "int")
type Int Nat32

type Data Int

type Node record {
	next: *Node
	data: *Data
}

let arrSize = 10
type Arr [arrSize]Int

/*func getArr() -> Arr {
	return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
}*/


func mid(a: Int, b: Int) -> Int {
	let sum = a + b
	return div(sum, 2)
}


@inline
export func div(a: Int, b: Int) -> Int {
	return a / b
}

