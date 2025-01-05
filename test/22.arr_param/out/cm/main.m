
@c_include "stdio.h"
include "libc/stdio"
func getarr10() -> [10]Int32 {
	return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
}
func arraysAdd(a: [10]Int32, b: [10]Int32) -> [10]Int32 {
	var c: [10]Int32
	var i: Int32 = 0
	while i < 10 {
		c[i] = a[i] + b[i]
		i = i + 1
	}
	return c
}


public func main() -> Int32 {
	let a = getarr10()

	if a == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] {
		printf("test1 passed!\n")
	}

	let b = [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]

	let c = arraysAdd(a, b)

	if c == [00, 11, 22, 33, 44, 55, 66, 77, 88, 99] {
		printf("test2 passed!\n")
	}

	let d = arraysAdd(a, a)

	if d == [0, 2, 4, 6, 8, 10, 12, 14, 16, 18] {
		printf("test3 passed!\n")
	}

	var i: Int32 = 0
	while i < 10 {
		printf("d[%i] = %i\n", i, d[i])
		i = i + 1
	}

	return 0
}

