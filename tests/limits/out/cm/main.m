include "ctypes64"
include "stdlib"
include "stdio"



const _int8Min = -128
const _int8Max = 127

const _int16Min = -32768
const _int16Max = 32767

const _int32Min = -2147483648
const _int32Max = 2147483647

const _int64Min = -9223372036854775808
const _int64Max = 9223372036854775807


const _nat8Max = 255
const _nat16Max = 65535
const _nat32Max = 4294967295
const _nat64Max = 18446744073709551615


//const float32Max       = Float32 3.4028234663852886e+38
//const float32MinNormal = Float32 1.1754943508222875e-38
//const float32MinSub    = Float32 1.401298464324817e-45
//const float32Epsilon   = Float32 1.1920928955078125e-7
//
//const float32PosInf    = Float32 1.0 / 0.0
//const float32NaN       = Float32 0.0 / 0.0
//const float32NegInf    = Float32 -1.0 / 0.0
//
//const float64PosInf    = Float64 1.0 / 0.0
//const float64NaN       = Float64 0.0 / 0.0
//const float64NegInf    = Float64 -1.0 / 0.0


func assert (cond: Bool, msg: *Str8) -> Unit {
	if not cond {
		printf("ASSERT FAILED: %s\n", msg)
		abort()
	}
}


// ------------------------------------------------------------
// Signed integers
// ------------------------------------------------------------

func testInt8 () -> Unit {
	let min = Int8 -128
	let max = Int8 127

	assert(min < 0, "Int8 min < 0")
	assert(max > 0, "Int8 max > 0")

	assert(Int8 -1 < Int8 0, "Int8 sign")
	assert(Int8 1 > Int8 0, "Int8 positive")

	assert((max + 1) == min, "Int8 overflow up")
	assert((min - 1) == max, "Int8 overflow down")
}


func testInt16 () -> Unit {
	let min = Int16 -32768
	let max = Int16 32767

	assert(min < 0, "Int16 min < 0")
	assert(max > 0, "Int16 max > 0")

	assert((max + 1) == min, "Int16 overflow up")
	assert((min - 1) == max, "Int16 overflow down")
}


func testInt32 () -> Unit {
	let min = Int32 -2147483648
	let max = Int32 2147483647

	assert(min < 0, "Int32 min < 0")
	assert(max > 0, "Int32 max > 0")

	assert((max + 1) == min, "Int32 overflow up")
	assert((min - 1) == max, "Int32 overflow down")
}


func testInt64 () -> Unit {
	let min = Int64 -9223372036854775808
	let max = Int64 9223372036854775807

	assert(min < 0, "Int64 min < 0")
	assert(max > 0, "Int64 max > 0")

	assert((max + 1) == min, "Int64 overflow up")
	assert((min - 1) == max, "Int64 overflow down")
}


// ------------------------------------------------------------
// Unsigned integers
// ------------------------------------------------------------

func testNat8 () -> Unit {
	let max = Nat8 255

	assert((max + 1) == 0, "Nat8 overflow up")
}


func testNat16 () -> Unit {
	let max = Nat16 65535

	assert((max + 1) == 0, "Nat16 overflow up")
}


func testNat32 () -> Unit {
	let max = Nat32 4294967295

	assert((max + 1) == 0, "Nat32 overflow up")
}


func testNat64 () -> Unit {
	let max = Nat64 18446744073709551615

	assert((max + 1) == 0, "Nat64 overflow up")
}


// ------------------------------------------------------------
// Float32
// ------------------------------------------------------------

func testFloat32 () -> Unit {

	let zero = Float32 .0
	let one = Float32 1.0
	let minus_one = Float32 -1.0

	assert(one > zero, "Float32 positive")
	assert(minus_one < zero, "Float32 negative")

	// Проверка деления
	assert(one / one == one, "Float32 division")

	// Infinity
	let inf: Float32 = one / zero
	assert(inf > one, "Float32 +inf")

	// NaN
	let nan: Float32 = zero / zero
	assert(not (nan == nan), "Float32 NaN")
}


// ------------------------------------------------------------
// Float64
// ------------------------------------------------------------

func testFloat64 () -> Unit {

	let zero = Float64 .0
	let one = Float64 1.0

	let inf: Float64 = one / zero
	assert(inf > one, "Float64 +inf")

	let nan: Float64 = zero / zero
	assert(not (nan == nan), "Float64 NaN")
}


// ------------------------------------------------------------
// Entry
// ------------------------------------------------------------

public func main () -> Int32 {
	printf("numeric boundary tests\n")

	//
	//	let f = 3.1415926535897932384626433832795028841971693993751058209749445923
	//	var f32 = Float32 f
	//	var f64 = Float64 f
	//
	//	printf("f32 = %.9g\n", f32)
	//	printf("f64 = %.17g\n", f64)
	//
	////	if f32 == 3.14 {
	////		printf("ok1\n")
	////	}
	//
	//	if f64 == 3.1415926535897931 {
	//		printf("ok2\n")
	//	}

	//	let n8 = Nat8 (_nat8Max + 1)
	//	printf("n8 = %i\n", Word32 n8)
	//
	//	let n16 = Nat16 (_nat16Max + 1)
	//	printf("n16 = %u\n", Word32 n16)
	//
	//	let n32 = Nat32 (_nat32Max + 1)
	//	printf("n32 = %u\n", Word32 n32)
	//
	//	let n64 = Nat64 (_nat64Max + 1)
	//	printf("n64 = %llu\n", Word64 n64)


	//	let i8 = Nat8 (127 + 1)
	//	printf("i8 = %i\n", i8)

	testInt8()
	testInt16()
	testInt32()
	testInt64()

	testNat8()
	testNat16()
	testNat32()
	testNat64()

	testFloat32()
	testFloat64()

	printf("OK\n")

	return 0
}

