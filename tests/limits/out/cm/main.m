include "ctypes64"
include "stdlib"
include "stdio"
include "limits"


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


const nat8MaxValuePlusOne: Nat8 = Nat8 nat8MaxValue + 1
const nat8MinValueMinusOne: Nat8 = Nat8 nat8MinValue - 1
const nat16MaxValuePlusOne: Nat16 = Nat16 nat16MaxValue + 1
const nat16MinValueMinusOne: Nat16 = Nat16 nat16MinValue - 1
const nat32MaxValuePlusOne: Nat32 = Nat32 nat32MaxValue + 1
const nat32MinValueMinusOne: Nat32 = Nat32 nat32MinValue - 1
const nat64MaxValuePlusOne: Nat64 = Nat64 nat64MaxValue + 1
const nat64MinValueMinusOne: Nat64 = Nat64 nat64MinValue - 1

const int8MaxValuePlusOne: Int8 = Int8 int8MaxValue + 1
const int8MinValueMinusOne: Int8 = Int8 int8MinValue - 1
const int16MaxValuePlusOne: Int16 = Int16 int16MaxValue + 1
const int16MinValueMinusOne: Int16 = Int16 int16MinValue - 1
const int32MaxValuePlusOne: Int32 = Int32 int32MaxValue + 1
const int32MinValueMinusOne: Int32 = Int32 int32MinValue - 1
const int64MaxValuePlusOne: Int64 = Int64 int64MaxValue + 1
const int64MinValueMinusOne: Int64 = Int64 int64MinValue - 1


func testNat8Static () -> Bool {
	if nat8MaxValue <= nat8MinValue {
		printf("error: nat8MaxValue <= nat8MinValue\n")
		return false
	}

	if nat8MaxValuePlusOne != nat8MinValue {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n")
		return false
	}

	if nat8MinValueMinusOne != nat8MaxValue {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n")
		return false
	}

	printf("passed: Nat8 test\n")
	return true
}


func testNat16Static () -> Bool {
	if nat16MaxValue <= nat16MinValue {
		printf("error: nat16MaxValue <= nat16MinValue\n")
		return false
	}

	if nat16MaxValuePlusOne != nat16MinValue {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n")
		return false
	}

	if nat16MinValueMinusOne != nat16MaxValue {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n")
		return false
	}

	printf("passed: Nat16 test\n")
	return true
}


func testNat32Static () -> Bool {
	if nat32MaxValue <= nat32MinValue {
		printf("error: nat32MaxValue <= nat32MinValue\n")
		return false
	}

	if nat32MaxValuePlusOne != nat32MinValue {
		printf("error: nat32MaxValuePlusOne != nat32MinValue\n")
		return false
	}

	if nat32MinValueMinusOne != nat32MaxValue {
		printf("error: nat32MinValueMinusOne != nat32MaxValue\n")
		return false
	}

	printf("passed: Nat32 test\n")
	return true
}


func testNat64Static () -> Bool {
	if nat64MaxValue <= nat64MinValue {
		printf("error: nat64MaxValue <= nat64MinValue\n")
		return false
	}

	if nat64MaxValuePlusOne != nat64MinValue {
		printf("error: nat64MaxValuePlusOne != nat64MinValue\n")
		return false
	}

	if nat64MinValueMinusOne != nat64MaxValue {
		printf("error: nat64MinValueMinusOne != nat64MaxValue\n")
		return false
	}

	printf("passed: Nat64 test\n")
	return true
}




func testInt8Static () -> Bool {
	if int8MinValue >= 0 {
		printf("error: int8MinValue >= 0\n")
		return false
	}

	if int8MaxValue <= 0 {
		printf("error: int8MaxValue <= 0\n")
		return false
	}

	if int8MaxValue <= int8MinValue {
		printf("error: int8MaxValue <= int8MinValue\n")
		return false
	}

	if int8MaxValuePlusOne != int8MinValue {
		printf("error: int8MaxValuePlusOne != int8MinValue\n")
		return false
	}

	if int8MinValueMinusOne != int8MaxValue {
		printf("error: int8MinValueMinusOne != int8MaxValue\n")
		return false
	}

	printf("passed: Int8 test\n")
	return true
}


func testInt16Static () -> Bool {
	if int16MinValue >= 0 {
		printf("error: int16MinValue >= 0\n")
		return false
	}

	if int16MaxValue <= 0 {
		printf("error: int16MaxValue <= 0\n")
		return false
	}

	if int16MaxValue <= int16MinValue {
		printf("error: int16MaxValue <= int16MinValue\n")
		return false
	}

	if int16MaxValuePlusOne != int16MinValue {
		printf("error: int16MaxValuePlusOne != int16MinValue\n")
		return false
	}

	if int16MinValueMinusOne != int16MaxValue {
		printf("error: int16MinValueMinusOne != int16MaxValue\n")
		return false
	}

	printf("passed: Int16 test\n")
	return true
}


func testInt32Static () -> Bool {
	if int32MinValue >= 0 {
		printf("error: int32MinValue >= 0\n")
		return false
	}

	if int32MaxValue <= 0 {
		printf("error: int32MaxValue <= 0\n")
		return false
	}

	if int32MaxValue <= int32MinValue {
		printf("error: int32MaxValue <= int32MinValue\n")
		return false
	}

	if int32MaxValuePlusOne != int32MinValue {
		printf("error: int32MaxValuePlusOne != int32MinValue\n")
		return false
	}

	if int32MinValueMinusOne != int32MaxValue {
		printf("error: int32MinValueMinusOne != int32MaxValue\n")
		return false
	}

	printf("passed: Int32 test\n")
	return true
}


func testInt64Static () -> Bool {
	if int64MinValue >= 0 {
		printf("error: int64MinValue >= 0\n")
		return false
	}

	if int64MaxValue <= 0 {
		printf("error: int64MaxValue <= 0\n")
		return false
	}

	if int64MaxValue <= int64MinValue {
		printf("error: int64MaxValue <= int64MinValue\n")
		return false
	}

	if int64MaxValuePlusOne != int64MinValue {
		printf("error: int64MaxValuePlusOne != int64MinValue\n")
		return false
	}

	if int64MinValueMinusOne != int64MaxValue {
		printf("error: int64MinValueMinusOne != int64MaxValue\n")
		return false
	}

	printf("passed: Int64 test\n")
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


func assert (x: Bool) -> Unit {
	//
}


public func main () -> Int32 {
	printf("numeric boundary tests\n")

	assert(testRational())

	assert(testNat8Static())
	assert(testNat16Static())
	assert(testNat32Static())
	assert(testNat64Static())

	assert(testInt8Static())
	assert(testInt16Static())
	assert(testInt32Static())
	assert(testInt64Static())

	printf("OK\n")

	return 0
}

