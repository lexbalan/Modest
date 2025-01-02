
@c_include "stdio.h"
include "libc/stdio"


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

func test_arrays() -> Unit {
	var i: Int32
	var j: Int32
	var k: Int32

	i = 0
	while i < 2 {
		j = 0
		while j < 2 {
			k = 0
			while k < 5 {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i][j][k])
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
			printf("a3[%d][%d] = %d\n", i, j, a3[i][j])
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
				printf("a3[%d][%d][%d] = %d\n", i, j, k, a4[i][j][k])
				k = k + 1
			}
			j = j + 1
		}
		i = i + 1
	}
}


type Point record {
	x: Int32
	y: Int32
}

type Line record {
	a: Point
	b: Point
}

var line: Line = {
	a = {x = 10, y = 11}
	b = {x = 12, y = 13}
}

var lines: [3]Line = [
	Line {
		a = {x = 1, y = 2}
		b = {x = 3, y = 4}
	}
	Line {
		a = {x = 5, y = 6}
		b = {x = 7, y = 8}
	}
	Line {
		a = {x = 9, y = 10}
		b = {x = 11, y = 12}
	}
]

var pLines: [3]*Line = [&lines[0], &lines[1], &lines[2]]

type Struct record {
	x: *Line
}

var s: Struct = {x = &lines[0]}


func test_records() -> Unit {

	printf("line.a.x = %d\n", line.a.x)
	printf("line.a.y = %d\n", line.a.y)

	printf("line.b.x = %d\n", line.b.x)
	printf("line.b.y = %d\n", line.b.y)

	printf("pLines[0].a.x = %d\n", pLines[0].a.x)
	printf("pLines[0].a.y = %d\n", pLines[0].a.y)

	printf("pLines[0].b.x = %d\n", pLines[0].b.x)
	printf("pLines[0].b.y = %d\n", pLines[0].b.y)

	printf("s.x.a.x = %d\n", s.x.a.x)
	printf("s.x.a.y = %d\n", s.x.a.y)

	printf("s.x.b.x = %d\n", s.x.b.x)
	printf("s.x.b.y = %d\n", s.x.b.y)


	let x = s

	printf("x.x.a.x = %d\n", x.x.a.x)
	printf("x.x.a.y = %d\n", x.x.a.y)

	printf("x.x.b.x = %d\n", x.x.b.x)
	printf("x.x.b.y = %d\n", x.x.b.y)
}


public func main() -> Int32 {
	//test_arrays()
	test_records()
	return 0
}

