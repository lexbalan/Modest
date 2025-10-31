
@c_include "stdio.h"
include "libc/stdio"
@c_include "stdlib.h"
include "libc/stdlib"
@c_include "string.h"
include "libc/string"


const m = 3
const n = 3
const p = 3

var a: [m][n][p]Int32 = [
	[
		[1, 2, 3]
		[4, 5, 6]
		[7, 8, 9]
	]

	[
		[11, 12, 13]
		[14, 15, 16]
		[17, 18, 19]
	]

	[
		[21, 22, 23]
		[24, 25, 26]
		[27, 28, 29]
	]
]

var b: [m][n]*[p]Int32 = [
	[
		&((a[0])[0])
		&((a[0])[1])
		&((a[0])[2])
	]

	[
		&((a[1])[0])
		&((a[1])[1])
		&((a[1])[2])
	]

	[
		&((a[2])[0])
		&((a[2])[1])
		&((a[2])[2])
	]
]


func test0() -> Unit {
	printf("test0:\n")
	printf("sizeof(a) = %d\n", Int32 (sizeof a))
	var i: Int32 = 0
	while i < m {
		var j: Int32 = 0
		while j < n {
			var k: Int32 = 0
			while k < p {
				let v = ((a[i])[j])[k]
				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}


func test1(pa: *[][][]Int32, m: Int32, n: Int32, p: Int32) -> Unit {
	printf("test1:\n")

	let pa2 = *[m][n][p]Int32 pa

	var local: [m][n][p]Int32 = *pa2

	printf("sizeof(pa2) = %d\n", Int32 (sizeof pa2))
	printf("sizeof(*pa2) = %d\n", sizeof *pa2)

	var i: Int32 = 0
	while i < m {
		var j: Int32 = 0
		while j < n {
			var k: Int32 = 0
			while k < p {
				let v = ((pa2[i])[j])[k]
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v)
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}


func test2(pa: *[][]*[]Int32, m: Int32, n: Int32, p: Int32) -> Unit {
	printf("test2:\n")

	let pa2 = *[m][n]*[p]Int32 pa

	printf("sizeof(pa2) = %d\n", Int32 (sizeof pa2))
	printf("sizeof(*pa2) = %d\n", sizeof *pa2)

	var i: Int32 = 0
	while i < m {
		var j: Int32 = 0
		while j < n {
			var k: Int32 = 0
			while k < p {
				let v = ((pa2[i])[j])[k]
				printf("pa2[%d][%d][%d] = %d\n", i, j, k, v)
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}


public func main() -> Int32 {
	test0()
	test1(&a, m, n, p)
	test2(&b, m, n, p)
	return 0
}

