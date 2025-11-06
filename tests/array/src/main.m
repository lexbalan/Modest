// tests/array/src/main.m

include "libc/ctypes64"
include "libc/stdio"


const c0 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const c1 = "Hello!"
const c2 = *Str8 "Hello!"
const c3 = *Str16 "Hello!"
const c4 = *Str32 "Hello!"
const c5 = Int32 32

var arr0: [10]Int32
var arr1: [10]Int32 = c0
var arr2: [10]Char32 = c1


func f0 (x: []Int32) -> []Int32 {

}

public func main () -> Int {
	printf("array test\n")

	var lar0: [10]Int32
	var lar1: [10]Int32 = [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]
	var lar2 = arr2

	printArrayOf10Char32(lar2)

	lar0 = sum10IntArrays(arr1, lar1)
	var i = Nat32 0
	while i < 10 {
		printf("a[%d] = %d\n", i, lar0[i])
		++i
	}

	return 0
}


func printArrayOf10Char32 (a: [10]Char32) -> Unit {
	var i = Nat32 0
	while i < lengthof(a) {
		printf("a[%d] = '%c'\n", i, a[i])
		++i
	}
}


func sum10IntArrays (a: [10]Int32, b: [10]Int32) -> [10]Int32 {
	var result: [10]Int32
	var i = Nat32 0
	while i < 10 {
		result[i] = a[i] + b[i]
		++i
	}
	return result
}


