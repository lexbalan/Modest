
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>



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

// error:
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

static bool testNat8Static(void) {
	uint8_t nat8;
	nat8 = (uint8_t)UINT8_MAX;// ok
	nat8 = (uint8_t)0;// ok
	//nat8 = nat8MaxValue + 1  // error: unsigned integer overflow
	//nat8 = nat8MinValue - 1  // error: unsigned integer overflow

	uint8_t _nat8MaxValue = (uint8_t)UINT8_MAX;
	uint8_t _nat8MinValue = (uint8_t)0;

	if (_nat8MaxValue <= _nat8MinValue) {
		printf("error: nat8MaxValue <= nat8MinValue\n");
		return false;
	}

	if ((uint8_t)(_nat8MaxValue + 1) != _nat8MinValue) {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n");
		return false;
	}

	if ((uint8_t)(_nat8MinValue - 1) != _nat8MaxValue) {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n");
		return false;
	}

	printf("passed: Nat8 test\n");
	return true;
}


static bool testNat16Static(void) {
	uint16_t nat16;
	nat16 = (uint16_t)UINT16_MAX;// ok
	nat16 = (uint16_t)0;// ok
	//nat16 = nat16MaxValue + 1  // error: unsigned integer overflow
	//nat16 = nat16MinValue - 1  // error: unsigned integer overflow

	uint16_t _nat16MinValue = (uint16_t)0;
	uint16_t _nat16MaxValue = (uint16_t)UINT16_MAX;

	if (_nat16MaxValue <= _nat16MinValue) {
		printf("error: nat16MaxValue <= nat16MinValue\n");
		return false;
	}

	if ((uint16_t)(_nat16MaxValue + 1) != _nat16MinValue) {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n");
		return false;
	}

	if ((uint16_t)(_nat16MinValue - 1) != _nat16MaxValue) {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n");
		return false;
	}

	printf("passed: Nat16 test\n");
	return true;
}


static bool testNat32Static(void) {
	uint32_t nat32;
	nat32 = (uint32_t)UINT32_MAX;// ok
	nat32 = (uint32_t)0;// ok
	//nat32 = nat32MaxValue + 1  // error: unsigned integer overflow
	//nat32 = nat32MinValue - 1  // error: unsigned integer overflow

	uint32_t _nat32MaxValue = (uint32_t)UINT32_MAX;
	uint32_t _nat32MinValue = (uint32_t)0;

	if (_nat32MaxValue <= _nat32MinValue) {
		printf("error: nat32MaxValue <= nat32MinValue\n");
		return false;
	}

	if (_nat32MaxValue + 1 != _nat32MinValue) {
		printf("error: nat32MaxValuePlusOne != nat32MinValue\n");
		return false;
	}

	if (_nat32MinValue - 1 != _nat32MaxValue) {
		printf("error: nat32MinValueMinusOne != nat32MaxValue\n");
		return false;
	}

	printf("passed: Nat32 test\n");
	return true;
}


static bool testNat64Static(void) {
	uint64_t nat64;
	nat64 = (uint64_t)UINT64_MAX;// ok
	nat64 = (uint64_t)0;// ok
	//nat64 = nat64MaxValue + 1  // error: unsigned integer overflow
	//nat64 = nat64MinValue - 1  // error: unsigned integer overflow

	uint64_t _nat64MaxValue = (uint64_t)UINT64_MAX;
	uint64_t _nat64MinValue = (uint64_t)0;

	if (_nat64MaxValue <= _nat64MinValue) {
		printf("error: nat64MaxValue <= nat64MinValue\n");
		return false;
	}

	if (_nat64MaxValue + 1 != _nat64MinValue) {
		printf("error: nat64MaxValuePlusOne != nat64MinValue\n");
		return false;
	}

	if (_nat64MinValue - 1 != _nat64MaxValue) {
		printf("error: nat64MinValueMinusOne != nat64MaxValue\n");
		return false;
	}

	printf("passed: Nat64 test\n");
	return true;
}


static bool testInt8Static(void) {
	int8_t int8;
	int8 = (int8_t)INT8_MAX;// ok
	int8 = (int8_t)INT8_MIN;// ok
	//int8 = int8MaxValue + 1  // error: integer overflow
	//int8 = int8MinValue - 1  // error: integer overflow

	int8_t _int8MinValue = (int8_t)INT8_MIN;
	int8_t _int8MaxValue = (int8_t)INT8_MAX;

	if (_int8MinValue >= 0) {
		printf("error: int8MinValue >= 0\n");
		return false;
	}

	if (_int8MaxValue <= 0) {
		printf("error: int8MaxValue <= 0\n");
		return false;
	}

	if (_int8MaxValue <= _int8MinValue) {
		printf("error: int8MaxValue <= int8MinValue\n");
		return false;
	}

	if ((int8_t)(_int8MaxValue + 1) != _int8MinValue) {
		printf("error: int8MaxValuePlusOne != int8MinValue\n");
		return false;
	}

	if ((int8_t)(_int8MinValue - 1) != _int8MaxValue) {
		printf("error: int8MinValueMinusOne != int8MaxValue\n");
		return false;
	}

	printf("passed: Int8 test\n");
	return true;
}


static bool testInt16Static(void) {
	int16_t int16;
	int16 = (int16_t)INT16_MAX;// ok
	int16 = (int16_t)INT16_MIN;// ok
	//int16 = int16MaxValue + 1  // error: integer overflow
	//int16 = int16MinValue - 1  // error: integer overflow

	int16_t _int16MinValue = (int16_t)INT16_MIN;
	int16_t _int16MaxValue = (int16_t)INT16_MAX;

	if (_int16MinValue >= 0) {
		printf("error: int16MinValue >= 0\n");
		return false;
	}

	if (_int16MaxValue <= 0) {
		printf("error: int16MaxValue <= 0\n");
		return false;
	}

	if (_int16MaxValue <= _int16MinValue) {
		printf("error: int16MaxValue <= int16MinValue\n");
		return false;
	}

	if ((int16_t)(_int16MaxValue + 1) != _int16MinValue) {
		printf("error: int16MaxValuePlusOne != int16MinValue\n");
		return false;
	}

	if ((int16_t)(_int16MinValue - 1) != _int16MaxValue) {
		printf("error: int16MinValueMinusOne != int16MaxValue\n");
		return false;
	}

	printf("passed: Int16 test\n");
	return true;
}


static bool testInt32Static(void) {
	int32_t int32;
	int32 = (int32_t)INT32_MAX;// ok
	int32 = (int32_t)INT32_MIN;// ok
	//int32 = int32MaxValue + 1  // error: integer overflow
	//int32 = int32MinValue - 1  // error: integer overflow

	int32_t _int32MinValue = (int32_t)INT32_MIN;
	int32_t _int32MaxValue = (int32_t)INT32_MAX;

	if (_int32MinValue >= 0) {
		printf("error: int32MinValue >= 0\n");
		return false;
	}

	if (_int32MaxValue <= 0) {
		printf("error: int32MaxValue <= 0\n");
		return false;
	}

	if (_int32MaxValue <= _int32MinValue) {
		printf("error: int32MaxValue <= int32MinValue\n");
		return false;
	}

	if (_int32MaxValue + 1 != _int32MinValue) {
		printf("error: int32MaxValuePlusOne != int32MinValue\n");
		return false;
	}

	if (_int32MinValue - 1 != _int32MaxValue) {
		printf("error: int32MinValueMinusOne != int32MaxValue\n");
		return false;
	}

	printf("passed: Int32 test\n");
	return true;
}


static bool testInt64Static(void) {
	int64_t _int64MinValue = (int64_t)INT64_MIN;
	int64_t _int64MaxValue = (int64_t)INT64_MAX;

	int64_t int64;
	int64 = (int64_t)INT64_MAX;// ok
	int64 = (int64_t)INT64_MIN;// ok
	//int64 = int64MaxValue + 1  // error: integer overflow
	//int64 = int64MinValue - 1  // error: integer overflow


	if (_int64MinValue >= 0) {
		printf("error: int64MinValue >= 0\n");
		return false;
	}

	if (_int64MaxValue <= 0) {
		printf("error: int64MaxValue <= 0\n");
		return false;
	}

	if (_int64MaxValue <= _int64MinValue) {
		printf("error: int64MaxValue <= int64MinValue\n");
		return false;
	}

	if (_int64MaxValue + 1 != _int64MinValue) {
		printf("error: int64MaxValuePlusOne != int64MinValue\n");
		return false;
	}

	if (_int64MinValue - 1 != _int64MaxValue) {
		printf("error: int64MinValueMinusOne != int64MaxValue\n");
		return false;
	}

	printf("passed: Int64 test\n");
	return true;
}


static bool testInteger(void) {
	printf("passed: Integer test\n");
	return true;
}


static bool testNatural(void) {
	printf("passed: Natural test\n");

	return true;
}


static bool testRational(void) {
	#define pi  (3.14)
	if (pi != 3.14) {
		printf("error: pi != 3.14\n");
		return false;
	}

	#define npi  ((int)pi)
	if ((int8_t)npi != 3) {
		printf("%d", (int32_t)npi);
		printf("error: npi != 3\n");
		return false;
	}

	printf("passed: Rational test\n");
	return true;

#undef pi
#undef npi
}


int32_t main(void) {
	printf("test numeric boundary:\n");

	bool result;
	bool success = true;

	// test built-in generic types
	result = testInteger();
	success = success && result;
	result = testNatural();
	success = success && result;
	result = testRational();
	success = success && result;

	// test built-in unsigned integer types
	result = testNat8Static();
	success = success && result;
	result = testNat16Static();
	success = success && result;
	result = testNat32Static();
	success = success && result;
	result = testNat64Static();
	success = success && result;

	// test built-in signed integer types
	result = testInt8Static();
	success = success && result;
	result = testInt16Static();
	success = success && result;
	result = testInt32Static();
	success = success && result;
	result = testInt64Static();
	success = success && result;


	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


