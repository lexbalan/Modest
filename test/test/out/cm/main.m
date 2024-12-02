
@c_include "stdio.h"
include "libc/stdio"
func getarr10() -> [10]Int32 {
	return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
}
func arrAddToAll(a: [10]Int32, x: Int32) -> [10]Int32 {
	var b: [10]Int32
	var i: Int32 = 0
	while i < 10 {
		b[i] = a[i] + x
		i = i + 1
	}
	return b
}
public func main() -> Int32 {
	let a = getarr10()

	if a == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] {
		printf("test1 passed!\n")
	}

	let b = arrAddToAll(a, 1)

	if b == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] {
		printf("test2 passed!\n")
	}

	let c = arrAddToAll([0, 10, 20, 30, 40, 50, 60, 70, 80, 90], 5)

	if c == [5, 15, 25, 35, 45, 55, 65, 75, 85, 95] {
		printf("test3 passed!\n")
	}

	var i: Int32 = 0
	while i < 10 {
		printf("c[%i] = %i\n", i, c[i])
		i = i + 1
	}

	return 0
}

