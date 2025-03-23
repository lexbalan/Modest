// tests/pre1/src/main.m

$pragma c_include "stdio.h"
include "stdio"

import "sub"
//import "list"

let add = &sub.add


var x: sub.MyInt


public public func main() -> Int {
	printf("test\n")

	printf("sub.name = '%s'\n", *Str8 sub.name)
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	var f: Float

	var y = default

	let a = 10
	let b = 20
	let s = sub.mid(a, b)
	printf("s = %d\n", s)

	let d = div(10, 2)

	let e = add(d, 1)

	var xx: Int

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12


//	let list = list.create()

	return 0
}


let default = 5


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


func div(a: Int, b: Int) -> Int {
	return a / b
}

