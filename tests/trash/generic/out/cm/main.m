import "builtin"
include "ctypes64"
include "stdio"
include "math"



public func main () -> Int {
	printf("generic types test\n")

	let t1: Bool = test_generic_integer()
	if t1 {
		printf("test_generic_integer passed\n")
	} else {
		printf("test_generic_integer failed\n")
	}

	let t2: Bool = test_generic_float()
	if t2 {
		printf("test_generic_float passed\n")
	} else {
		printf("test_generic_float failed\n")
	}

	let t3: Bool = test_generic_char()
	if t3 {
		printf("test_generic_char passed\n")
	} else {
		printf("test_generic_char failed\n")
	}

	let t4: Bool = test_generic_array()
	if t4 {
		printf("test_generic_array passed\n")
	} else {
		printf("test_generic_array failed\n")
	}

	let t5: Bool = test_generic_record()
	if t5 {
		printf("test_generic_record passed\n")
	} else {
		printf("test_generic_integer failed\n")
	}

	return 0
}


func test_generic_integer () -> Bool {
	let one = 1
	let two = 1 + one
	var a: Int32 = one
	var b: Nat64 = one
	var f: Float32 = one
	var g: Float64 = one
	var x: Word8 = one

	var c = Char8 one
	var d = Char16 one
	var e = Char32 one

	var k: Bool = one != 0

	return true
}


func test_generic_float () -> Bool {
	let pi = 3.1415926535897932384626433832795028841971693993751058209749445923
	var f: Float32 = pi
	var g: Float64 = pi
	var x = Int32 pi

	return true
}


func test_generic_char () -> Bool {
	let a = "A"
	var b: Char8 = a
	var c: Char16 = a
	var d: Char32 = a
	var char_code = Int32 Word32 Char32 a

	return true
}


func test_generic_array () -> Bool {
	let a = [0, 1, 2, 3]

	var i: Nat32 = 0

	if a != [0, 1, 2, 3] {
		printf("error: a != [0, 1, 2, 3]\n")
		return false
	}
	var b: [4]Int32
	b = a

	if b != [0, 1, 2, 3] {
		printf("b != [0, 1, 2, 3]\n")
		return false
	}
	var c: [4]Int64
	c = a

	if c != [0, 1, 2, 3] {
		printf("c != [0, 1, 2, 3]\n")
		return false
	}
	var d = [10]Int32 a

	if d != [0, 1, 2, 3] {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n")
		return false
	}

	return true
}



type Point2D = {
	x: Int32
	y: Int32
}

type Point3D = {
	x: Int32
	y: Int32
	z: Int32
}


func test_generic_record () -> Bool {
	let p = {x = 10, y = 20}
	var point_2d: Point2D
	point_2d = p
	Unit point_2d
	var point_3d: Point3D
	point_3d = Point3D p
	Unit point_3d

	return true
}

