// tests/1.hello_world/src/main.m

include "libc/ctypes64"
include "libc/stdio"


public func main () -> Int {
	printf("generic types test\n")

	let t1 = test_generic_integer()
	if t1 {
		printf("test_generic_integer passed\n")
	} else {
		printf("test_generic_integer failed\n")
	}

	let t2 = test_generic_float()
	if t2 {
		printf("test_generic_float passed\n")
	} else {
		printf("test_generic_float failed\n")
	}

	let t3 = test_generic_char()
	if t3 {
		printf("test_generic_char passed\n")
	} else {
		printf("test_generic_char failed\n")
	}

	let t4 = test_generic_array()
	if t4 {
		printf("test_generic_array passed\n")
	} else {
		printf("test_generic_array failed\n")
	}

	let t5 = test_generic_record()
	if t5 {
		printf("test_generic_record passed\n")
	} else {
		printf("test_generic_integer failed\n")
	}

	return 0
}


func test_generic_integer () -> Bool {
	// Any integer literal have GenericInteger type
	let one = 1

	// result of such expressions also have generic type
	let two = 1 + one

	// GenericInteger value can be implicitly casted to any Integer type
	var a: Int32 = one  // implicit cast GenericInteger value to Int32
	var b: Nat64 = one  // implicit cast GenericInteger value to INat64

	// to Float
	var f: Float32 = one  // implicit cast GenericInteger value to Float32
	var g: Float64 = one  // implicit cast GenericInteger value to Float64

	// and to Word8
	var x: Word8 = one  // implicit cast GenericInteger value to Word8


	// explicit cast GenericInteger value

	var c: Char8 = Char8 one	// explicit cast GenericInteger value to Char8
	var d: Char16 = Char16 one  // explicit cast GenericInteger value to Char16
	var e: Char32 = Char32 one  // explicit cast GenericInteger value to Char32

	var k: Bool = one != 0  // explicit cast GenericInteger value to Bool

	return true
}


func test_generic_float () -> Bool {
	// Any float literal have GenericFloat type
	let pi = 3.141592653589793238462643383279502884

	// value with GenericFloat type
	// can be implicit casted to any Float type
	// (in this case value may lose precision)
	var f: Float32 = pi  // implicit cast GenericFloat value to Float32
	var g: Float64 = pi  // implicit cast GenericFloat value to Float64

	// explicit cast GenericFloat value to Int32
	var x: Int32 = Int32 pi

	return true
}


func test_generic_char () -> Bool {
	// Any char value expression have GenericChar type
	// (you can pick GenericChar value by index of GenericString value)
	let a = "A"

	// value with GenericChar type
	// can be implicit casted to any Char type
	var b: Char8 = a   // implicit cast GenericChar value to Char8
	var c: Char16 = a  // implicit cast GenericChar value to Char16
	var d: Char32 = a  // implicit cast GenericChar value to Char32

	// explicit cast GenericChar value to Int32
	var char_code: Int32 = Int32 Word32 Char32 a

	return true
}


func test_generic_array () -> Bool {
	// Any array expression have GenericArray type
	// this array expression (GenericArray of four GenericInteger items)
	let a = [0, 1, 2, 3]

	var i: Nat32 = 0
	while i < 4 {
		printf("a[%i] = %i\n", i, Nat32 a[i])
		++i
	}

	if a != [0, 1, 2, 3] {
		printf("error: a != [0, 1, 2, 3]\n")
		return false
	}

	// value with GenericArray type
	// can be implicit casted to Array with compatible type and same size

	// implicit cast Generic([4]GenericInteger) value to [4]Int32
	var b: [4]Int32
	b = a

	if b != [0, 1, 2, 3] {
		printf("b != [0, 1, 2, 3]\n")
		return false
	}

	// implicit cast Generic([4]GenericInteger) value to [4]Nat64
	var c: [4]Int64
	c = a

	if c != [0, 1, 2, 3] {
		printf("c != [0, 1, 2, 3]\n")
		return false
	}

	// explicit cast Generic([4]GenericInteger) value to [10]Int32
	var d: [10]Int32 = [10]Int32 a

	if d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0] {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n")
		return false
	}

	return true
}



type Point2D = record {
	x: Int32
	y: Int32
}

type Point3D = record {
	x: Int32
	y: Int32
	z: Int32
}


func test_generic_record () -> Bool {
	// Any record expression have GenericRecord type
	// this record expression have type:
	// Generic(record {x: GenericInteger, y: GenericInteger})
	let p = {x = 10, y = 20}

	// value with GenericRecord type
	// can be implicit casted to Record with same fields.

	// implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32}
	var point_2d: Point2D
	point_2d = p


	// explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	// to record {x: Int32, y: Int32, z: Int32}
	var point_3d: Point3D
	point_3d = Point3D p

	return true
}


