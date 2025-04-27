// tests/pre/src/main.m

//import "libc/stdio"

import "console"
import "sub"
import "sub2"

let print = &console::printf


var x: @volatile @atomic sub::Int


func increment() {
	++sub::subCnt
}

public func main() -> sub::Int {
	print("test\n")

	print("sub::subName = '%s'\n", *Str8 sub::subName)
	print("sub2::sub2Name = '%s'\n", *Str8 sub2::sub2Name)

	var y = sub::default

	let a = 10
	let b = 20
	let s = mid(a, b)
	print("s = %d\n", s)

	var xx: sub::Int

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12

	return 0
}


@set("c", "arrshow")
@set("cm_alias", "arrshow")
func arrayShow(array: *Arr, size: sub::Int) -> Unit {
	print("arrayShow:\n")
	var i = 0
	while i < 10 {
		print("array[%d] = %d\n", i, array[i])
		++i
	}
}

type Data Nat32

type Node record {
	next: *Node
	data: *Data
}

let arrSize = 10
type Arr [arrSize]sub::Int

/*func getArr() -> Arr {
	return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
}*/


func mid(a: sub::Int, b: sub::Int) -> sub::Int {
	let sum = a + b
	return sub::div(sum, 2)
}


