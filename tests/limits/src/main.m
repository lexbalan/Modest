// tests/limits/src/main.m

include "libc/ctypes64"
include "libc/stdlib"
include "libc/stdio"
include "limits"


// constants check (ok)
const _nat8MaxValue = Nat8 nat8MaxValue
const _nat8MinValue = Nat8 nat8MinValue
const _nat16MaxValue = Nat16 nat16MaxValue
const _nat16MinValue = Nat16 nat16MinValue
const _nat32MaxValue = Nat32 nat32MaxValue
const _nat32MinValue = Nat32 nat32MinValue
const _nat64MaxValue = Nat64 nat64MaxValue
const _nat64MinValue = Nat64 nat64MinValue

const _int8MaxValue = Int8 int8MaxValue
const _int8MinValue = Int8 int8MinValue
const _int16MaxValue = Int16 int16MaxValue
const _int16MinValue = Int16 int16MinValue
const _int32MaxValue = Int32 int32MaxValue
const _int32MinValue = Int32 int32MinValue
const _int64MaxValue = Int64 int64MaxValue
const _int64MinValue = Int64 int64MinValue

// constants check (error)
//const nat8MaxValuePlusOne = Nat8 nat8MaxValue + 1
//const nat8MinValueMinusOne = Nat8 nat8MinValue - 1
//const nat16MaxValuePlusOne = Nat16 nat16MaxValue + 1
//const nat16MinValueMinusOne = Nat16 nat16MinValue - 1
//const nat32MaxValuePlusOne = Nat32 nat32MaxValue + 1
//const nat32MinValueMinusOne = Nat32 nat32MinValue - 1
//const nat64MaxValuePlusOne = Nat64 nat64MaxValue + 1
//const nat64MinValueMinusOne = Nat64 nat64MinValue - 1
//
//const int8MaxValuePlusOne = Int8 int8MaxValue + 1
//const int8MinValueMinusOne = Int8 int8MinValue - 1
//const int16MaxValuePlusOne = Int16 int16MaxValue + 1
//const int16MinValueMinusOne = Int16 int16MinValue - 1
//const int32MaxValuePlusOne = Int32 int32MaxValue + 1
//const int32MinValueMinusOne = Int32 int32MinValue - 1
//const int64MaxValuePlusOne = Int64 int64MaxValue + 1
//const int64MinValueMinusOne = Int64 int64MinValue - 1


//const float32MaxValue       = Float32 3.4028234663852886e+38
//const float32MinValueNormal = Float32 1.1754943508222875e-38
//const float32MinValueSub    = Float32 1.401298464324817e-45
//const float32Epsilon   = Float32 1.1920928955078125e-7
//
//const float32PosInf    = Float32 1.0 / 0.0
//const float32NaN       = Float32 0.0 / 0.0
//const float32NegInf    = Float32 -1.0 / 0.0
//
//const float64PosInf    = Float64 1.0 / 0.0
//const float64NaN       = Float64 0.0 / 0.0
//const float64NegInf    = Float64 -1.0 / 0.0



func testNat8Static () -> Bool {
	var nat8: Nat8
	nat8 = nat8MaxValue      // ok
	nat8 = nat8MinValue      // ok
	//nat8 = nat8MaxValue + 1  // error: unsigned integer overflow
	//nat8 = nat8MinValue - 1  // error: unsigned integer overflow

	var _nat8MaxValue: Nat8 = nat8MaxValue
	var _nat8MinValue: Nat8 = nat8MinValue

	if _nat8MaxValue <= _nat8MinValue {
		printf("error: nat8MaxValue <= nat8MinValue\n")
		return false
	}

	if _nat8MaxValue + 1 != _nat8MinValue {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n")
		return false
	}

	if _nat8MinValue - 1 != _nat8MaxValue {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n")
		return false
	}

	printf("passed: Nat8 test\n")
	return true
}


func testNat16Static () -> Bool {
	var nat16: Nat16
	nat16 = nat16MaxValue      // ok
	nat16 = nat16MinValue      // ok
	//nat16 = nat16MaxValue + 1  // error: unsigned integer overflow
	//nat16 = nat16MinValue - 1  // error: unsigned integer overflow

	var _nat16MinValue: Nat16 = nat16MinValue
	var _nat16MaxValue: Nat16 = nat16MaxValue

	if _nat16MaxValue <= _nat16MinValue {
		printf("error: nat16MaxValue <= nat16MinValue\n")
		return false
	}

	if _nat16MaxValue + 1 != _nat16MinValue {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n")
		return false
	}

	if _nat16MinValue - 1 != _nat16MaxValue {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n")
		return false
	}

	printf("passed: Nat16 test\n")
	return true
}


func testNat32Static () -> Bool {
	var nat32: Nat32
	nat32 = nat32MaxValue      // ok
	nat32 = nat32MinValue      // ok
	//nat32 = nat32MaxValue + 1  // error: unsigned integer overflow
	//nat32 = nat32MinValue - 1  // error: unsigned integer overflow

	var _nat32MaxValue: Nat32 = nat32MaxValue
	var _nat32MinValue: Nat32 = nat32MinValue

	if _nat32MaxValue <= _nat32MinValue {
		printf("error: nat32MaxValue <= nat32MinValue\n")
		return false
	}

	if _nat32MaxValue + 1 != _nat32MinValue {
		printf("error: nat32MaxValuePlusOne != nat32MinValue\n")
		return false
	}

	if _nat32MinValue - 1 != _nat32MaxValue {
		printf("error: nat32MinValueMinusOne != nat32MaxValue\n")
		return false
	}

	printf("passed: Nat32 test\n")
	return true
}


func testNat64Static () -> Bool {
	var nat64: Nat64
	nat64 = nat64MaxValue      // ok
	nat64 = nat64MinValue      // ok
	//nat64 = nat64MaxValue + 1  // error: unsigned integer overflow
	//nat64 = nat64MinValue - 1  // error: unsigned integer overflow

	var _nat64MaxValue: Nat64 = nat64MaxValue
	var _nat64MinValue: Nat64 = nat64MinValue

	if _nat64MaxValue <= _nat64MinValue {
		printf("error: nat64MaxValue <= nat64MinValue\n")
		return false
	}

	if _nat64MaxValue + 1 != _nat64MinValue {
		printf("error: nat64MaxValuePlusOne != nat64MinValue\n")
		return false
	}

	if _nat64MinValue - 1 != _nat64MaxValue {
		printf("error: nat64MinValueMinusOne != nat64MaxValue\n")
		return false
	}

	printf("passed: Nat64 test\n")
	return true
}




func testInt8Static () -> Bool {
	var int8: Int8
	int8 = int8MaxValue      // ok
	int8 = int8MinValue      // ok
	//int8 = int8MaxValue + 1  // error: integer overflow
	//int8 = int8MinValue - 1  // error: integer overflow

	var _int8MinValue: Int8 = int8MinValue
	var _int8MaxValue: Int8 = int8MaxValue

	if _int8MinValue >= 0 {
		printf("error: int8MinValue >= 0\n")
		return false
	}

	if _int8MaxValue <= 0 {
		printf("error: int8MaxValue <= 0\n")
		return false
	}

	if _int8MaxValue <= _int8MinValue {
		printf("error: int8MaxValue <= int8MinValue\n")
		return false
	}

	if _int8MaxValue + 1 != _int8MinValue {
		printf("error: int8MaxValuePlusOne != int8MinValue\n")
		return false
	}

	if _int8MinValue - 1 != _int8MaxValue {
		printf("error: int8MinValueMinusOne != int8MaxValue\n")
		return false
	}

	printf("passed: Int8 test\n")
	return true
}


func testInt16Static () -> Bool {
	var int16: Int16
	int16 = int16MaxValue      // ok
	int16 = int16MinValue      // ok
	//int16 = int16MaxValue + 1  // error: integer overflow
	//int16 = int16MinValue - 1  // error: integer overflow

	var _int16MinValue: Int16 = int16MinValue
	var _int16MaxValue: Int16 = int16MaxValue

	if _int16MinValue >= 0 {
		printf("error: int16MinValue >= 0\n")
		return false
	}

	if _int16MaxValue <= 0 {
		printf("error: int16MaxValue <= 0\n")
		return false
	}

	if _int16MaxValue <= _int16MinValue {
		printf("error: int16MaxValue <= int16MinValue\n")
		return false
	}

	if _int16MaxValue + 1 != _int16MinValue {
		printf("error: int16MaxValuePlusOne != int16MinValue\n")
		return false
	}

	if _int16MinValue - 1 != _int16MaxValue {
		printf("error: int16MinValueMinusOne != int16MaxValue\n")
		return false
	}

	printf("passed: Int16 test\n")
	return true
}


func testInt32Static () -> Bool {
	var int32: Int32
	int32 = int32MaxValue      // ok
	int32 = int32MinValue      // ok
	//int32 = int32MaxValue + 1  // error: integer overflow
	//int32 = int32MinValue - 1  // error: integer overflow

	var _int32MinValue: Int32 = int32MinValue
	var _int32MaxValue: Int32 = int32MaxValue

	if _int32MinValue >= 0 {
		printf("error: int32MinValue >= 0\n")
		return false
	}

	if _int32MaxValue <= 0 {
		printf("error: int32MaxValue <= 0\n")
		return false
	}

	if _int32MaxValue <= _int32MinValue {
		printf("error: int32MaxValue <= int32MinValue\n")
		return false
	}

	if _int32MaxValue + 1 != _int32MinValue {
		printf("error: int32MaxValuePlusOne != int32MinValue\n")
		return false
	}

	if _int32MinValue - 1 != _int32MaxValue {
		printf("error: int32MinValueMinusOne != int32MaxValue\n")
		return false
	}

	printf("passed: Int32 test\n")
	return true
}


func testInt64Static () -> Bool {
	var _int64MinValue: Int64 = int64MinValue
	var _int64MaxValue: Int64 = int64MaxValue

	var int64: Int64
	int64 = int64MaxValue      // ok
	int64 = int64MinValue      // ok
	//int64 = int64MaxValue + 1  // error: integer overflow
	//int64 = int64MinValue - 1  // error: integer overflow

	if _int64MinValue >= 0 {
		printf("error: int64MinValue >= 0\n")
		return false
	}

	if _int64MaxValue <= 0 {
		printf("error: int64MaxValue <= 0\n")
		return false
	}

	if _int64MaxValue <= _int64MinValue {
		printf("error: int64MaxValue <= int64MinValue\n")
		return false
	}

	if _int64MaxValue + 1 != _int64MinValue {
		printf("error: int64MaxValuePlusOne != int64MinValue\n")
		return false
	}

	if _int64MinValue - 1 != _int64MaxValue {
		printf("error: int64MinValueMinusOne != int64MaxValue\n")
		return false
	}

	printf("passed: Int64 test\n")
	return true
}



func testFloat32Static () -> Bool {
    var a: Float32 = 3.0
    var b: Float32 = 2.0

    if a + b != 5.0 {
		printf("3.0 + 2.0 != 5.0 (=%f)\n", a + b)
		return false
	}

    if a - b != 1.0 {
		printf("3.0 - 2.0 != 1.0 (=%f)\n", a - b)
		return false
	}

    if a * b != 6.0 {
		printf("3.0 * 2.0 != 6.0 (=%f)\n", a * b)
		return false
	}

	if a / b != 1.5 {
		printf("3.0 / 2.0 != 1.5 (=%f)\n", a / b)
		return false
	}

    return true
}




func testInteger () -> Bool {
	printf("passed: Integer test\n")
	return true
}


func testRational () -> Bool {
	let pi = Rational 3.14
	if pi != 3.14 {
		printf("error: pi != 3.14\n")
		return false
	}

	let npi = Integer pi
	if npi != 3 {
		printf("%d", Int32 npi)
		printf("error: npi != 3\n")
		return false
	}

	printf("passed: Rational test\n")
	return true
}



func main () -> Int32 {
	printf("test numeric boundary:\n")

	var result = true

	// test built-in generic types
	result = testInteger() and result
	result = testRational() and result

	// test built-in unsigned integer types
	result = testNat8Static() and result
	result = testNat16Static() and result
	result = testNat32Static() and result
	result = testNat64Static() and result

	// test built-in signed integer types
	result = testInt8Static() and result
	result = testInt16Static() and result
	result = testInt32Static() and result
	result = testInt64Static() and result

	//
	//result = testFloat32Static() and result

	printf("test ")
	if not result {
		printf("failed\n")
    	return exitFailure
	}

    printf("passed\n")
    return exitSuccess
}



