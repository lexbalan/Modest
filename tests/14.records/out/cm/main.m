include "ctypes64"
include "stdio"


type Point2D = record {
	x: Nat32
	y: Nat32
}

type Point3D = record {
	x: Nat32
	y: Nat32
	z: Nat32
}


const xx = {x = 1, y = 2}
const yy = Point2D {x = 1, y = 2}


type Point = record {
	x: Int32
	y: Int32
}

type Line = record {
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

type Struct = record {
	x: *Line
}

var s: Struct = {x = &lines[0]}


func test_records () -> Unit {

	type LocalRecord = record {
		x: Int32
	}

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


	let x: Struct = s

	printf("x.x.a.x = %d\n", x.x.a.x)
	printf("x.x.a.y = %d\n", x.x.a.y)

	printf("x.x.b.x = %d\n", x.x.b.x)
	printf("x.x.b.y = %d\n", x.x.b.y)
}


public func main () -> Int {
	printf("records test\n")

	// check value_record_eq for immediate values
	let ver = {name = "m2", version = {major = 0, minor = 7}}.version
	if ver == {major = 0, minor = 7} {
		printf("version 0.7\n")
	} else {
		printf("version not 0.7\n")
	}

	// compare two Point2D records
	var p2d0: Point2D = {x = 1, y = 2}
	var p2d1: Point2D = {x = 10, y = 20}

	if p2d0 == p2d1 {
		printf("p2d0 == p2d1\n")
	} else {
		printf("p2d0 != p2d1\n")
	}


	// compare Point2D with anonymous record
	var p2d2: Point2D = p2d0
	var p2d3: record {
		x: Nat32
		y: Nat32
	} = record {
		x: Nat32
		y: Nat32
	} xx

	if p2d2 == p2d3 {
		printf("p2d2 == p2d3\n")
	} else {
		printf("p2d2 != p2d3\n")
	}


	// comparison between two anonymous record
	var p2d4: record {
		x: Nat32
		y: Nat32
	} = record {
		x: Nat32
		y: Nat32
	} {x = 1, y = 2}

	if p2d3 == p2d4 {
		printf("p2d3 == p2d4\n")
	} else {
		printf("p2d3 != p2d4\n")
	}

	// comparison between two record (by pointer)
	let pr2: *Point2D = &p2d2
	let pr3: *record {
		x: Nat32
		y: Nat32
	} = &p2d3

	if *pr2 == *pr3 {
		printf("*pr2 == *pr3\n")
	} else {
		printf("*pr2 != *pr3\n")
	}

	/*
	var prx = &p2d2
	var prx2 = &prx
	var pry = &p2d3

	if **prx2 == *pry {
		printf("**prx2 == *pry\n")
	} else {
		printf("**prx2 != *pry\n")
	}
*/

	// assign record by pointer
	*pr2 = {x = 100, y = 200}
	*pr3 = {}

	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)  ((EXPERIMENTAL))
	var p3d: Point3D
	p3d = Point3D p2d2


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	var ax = Int32 10
	var bx = Int32 20

	let px = {x = ax, y = bx}

	ax = 111
	bx = 222

	printf("px.x = %i (must be 10)\n", px.x)
	printf("px.y = %i (must be 20)\n", px.y)

	if px == {x = 10, y = 20} {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	test_records()

	return 0
}

