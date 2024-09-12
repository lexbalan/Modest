// test/14.records/src/main.cm

include "libc/ctypes64"
include "libc/stdio"

type Point2D record {
	x: Nat32
	y: Nat32
}

type Point3D record {
	x: Nat32
	y: Nat32
	z: Nat32
}


let xx = {x=1, y=2}
let yy = Point2D {x=1, y=2}


func main() -> Int {
	printf("records test\n")

	// compare two Point2D records
	var p2d0: Point2D = {x=1, y=2}
	var p2d1: Point2D = {x=10, y = 20}

	if p2d0 == p2d1 {
		printf("p2d0 == p2d1\n")
	} else {
		printf("p2d0 != p2d1\n")
	}


	// compare Point2D with anonymous record
	var p2d2 = p2d0  // record assignation
	var p2d3 = record {x: Nat32, y: Nat32} xx

	if p2d2 == p2d3 {
		printf("p2d2 == p2d3\n")
	} else {
		printf("p2d2 != p2d3\n")
	}


	// comparison between two anonymous record
	var p2d4 = record {x: Nat32, y: Nat32} {x=1, y=2}

	if p2d3 == p2d4 {
		printf("p2d3 == p2d4\n")
	} else {
		printf("p2d3 != p2d4\n")
	}

	// comparison between two record (by pointer)
	let pr2 = &p2d2
	let pr3 = &p2d3

	if *pr2 == *pr3 {
		printf("*pr2 == *pr3\n")
	} else {
		printf("*pr2 != *pr3\n")
	}


	// assign record by pointer
	*pr2 = {x=100, y=200}
	*pr3 = {}

	// cons Point3D from Point2D (record extension)
	// (it is possible if dst record contained all fields from src record
	// and their types are equal)
	var p3d: Point3D
	p3d = Point3D p2d2


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	var ax = Int32 10
	var bx = Int32 20

	let px = {x=ax, y=bx}

	ax = 111
	bx = 222

	printf("px.x = %i (must be 10)\n", px.x)
	printf("px.y = %i (must be 20)\n", px.y)

	if px == {x=10, y=20} {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}


	return 0
}

