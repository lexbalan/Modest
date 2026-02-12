
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

#define NAT8_MAX_VALUE_PLUS_ONE  ((uint8_t)((uint8_t)UINT8_MAX + 1))
#define NAT8_MIN_VALUE_MINUS_ONE  ((uint8_t)((uint8_t)0 - 1))
#define NAT16_MAX_VALUE_PLUS_ONE  ((uint16_t)((uint16_t)UINT16_MAX + 1))
#define NAT16_MIN_VALUE_MINUS_ONE  ((uint16_t)((uint16_t)0 - 1))
#define NAT32_MAX_VALUE_PLUS_ONE  ((uint32_t)UINT32_MAX + 1)
#define NAT32_MIN_VALUE_MINUS_ONE  ((uint32_t)0 - 1)
#define NAT64_MAX_VALUE_PLUS_ONE  ((uint64_t)UINT64_MAX + 1)
#define NAT64_MIN_VALUE_MINUS_ONE  ((uint64_t)0 - 1)

#define INT8_MAX_VALUE_PLUS_ONE  ((int8_t)((int8_t)INT8_MAX + 1))
#define INT8_MIN_VALUE_MINUS_ONE  ((int8_t)((int8_t)INT8_MIN - 1))
#define INT16_MAX_VALUE_PLUS_ONE  ((int16_t)((int16_t)INT16_MAX + 1))
#define INT16_MIN_VALUE_MINUS_ONE  ((int16_t)((int16_t)INT16_MIN - 1))
#define INT32_MAX_VALUE_PLUS_ONE  ((int32_t)INT32_MAX + 1)
#define INT32_MIN_VALUE_MINUS_ONE  ((int32_t)INT32_MIN - 1)
#define INT64_MAX_VALUE_PLUS_ONE  ((int64_t)INT64_MAX + 1)
#define INT64_MIN_VALUE_MINUS_ONE  ((int64_t)INT64_MIN - 1)

static bool testNat8Static(void) {
	if (UINT8_MAX <= 0) {
		printf("error: nat8MaxValue <= nat8MinValue\n");
		return false;
	}

	if (NAT8_MAX_VALUE_PLUS_ONE != (const uint8_t)0) {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n");
		return false;
	}

	if (NAT8_MIN_VALUE_MINUS_ONE != (const uint8_t)UINT8_MAX) {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n");
		return false;
	}

	printf("passed: Nat8 test\n");
	return true;
}


static bool testNat16Static(void) {
	if (UINT16_MAX <= (const int16_t)0) {
		printf("error: nat16MaxValue <= nat16MinValue\n");
		return false;
	}

	if (NAT16_MAX_VALUE_PLUS_ONE != (const uint16_t)0) {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n");
		return false;
	}

	if (NAT16_MIN_VALUE_MINUS_ONE != (const uint16_t)UINT16_MAX) {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n");
		return false;
	}

	printf("passed: Nat16 test\n");
	return true;
}


static bool testNat32Static(void) {
	if (UINT32_MAX <= (const int32_t)0) {
		printf("error: nat32MaxValue <= nat32MinValue\n");
		return false;
	}

	if (NAT32_MAX_VALUE_PLUS_ONE != (const uint32_t)0) {
		printf("error: nat32MaxValuePlusOne != nat32MinValue\n");
		return false;
	}

	if (NAT32_MIN_VALUE_MINUS_ONE != (const uint32_t)UINT32_MAX) {
		printf("error: nat32MinValueMinusOne != nat32MaxValue\n");
		return false;
	}

	printf("passed: Nat32 test\n");
	return true;
}


static bool testNat64Static(void) {
	if (UINT64_MAX <= (const int64_t)0) {
		printf("error: nat64MaxValue <= nat64MinValue\n");
		return false;
	}

	if (NAT64_MAX_VALUE_PLUS_ONE != (const uint64_t)0) {
		printf("error: nat64MaxValuePlusOne != nat64MinValue\n");
		return false;
	}

	if (NAT64_MIN_VALUE_MINUS_ONE != (const uint64_t)UINT64_MAX) {
		printf("error: nat64MinValueMinusOne != nat64MaxValue\n");
		return false;
	}

	printf("passed: Nat64 test\n");
	return true;
}


static bool testInt8Static(void) {
	if (INT8_MIN >= 0) {
		printf("error: int8MinValue >= 0\n");
		return false;
	}

	if (INT8_MAX <= 0) {
		printf("error: int8MaxValue <= 0\n");
		return false;
	}

	if (INT8_MAX <= INT8_MIN) {
		printf("error: int8MaxValue <= int8MinValue\n");
		return false;
	}

	if (INT8_MAX_VALUE_PLUS_ONE != (const int8_t)INT8_MIN) {
		printf("error: int8MaxValuePlusOne != int8MinValue\n");
		return false;
	}

	if (INT8_MIN_VALUE_MINUS_ONE != (const int8_t)INT8_MAX) {
		printf("error: int8MinValueMinusOne != int8MaxValue\n");
		return false;
	}

	printf("passed: Int8 test\n");
	return true;
}


static bool testInt16Static(void) {
	if (INT16_MIN >= 0) {
		printf("error: int16MinValue >= 0\n");
		return false;
	}

	if (INT16_MAX <= 0) {
		printf("error: int16MaxValue <= 0\n");
		return false;
	}

	if (INT16_MAX <= INT16_MIN) {
		printf("error: int16MaxValue <= int16MinValue\n");
		return false;
	}

	if (INT16_MAX_VALUE_PLUS_ONE != (const int16_t)INT16_MIN) {
		printf("error: int16MaxValuePlusOne != int16MinValue\n");
		return false;
	}

	if (INT16_MIN_VALUE_MINUS_ONE != (const int16_t)INT16_MAX) {
		printf("error: int16MinValueMinusOne != int16MaxValue\n");
		return false;
	}

	printf("passed: Int16 test\n");
	return true;
}


static bool testInt32Static(void) {
	if (INT32_MIN >= 0) {
		printf("error: int32MinValue >= 0\n");
		return false;
	}

	if (INT32_MAX <= 0) {
		printf("error: int32MaxValue <= 0\n");
		return false;
	}

	if (INT32_MAX <= INT32_MIN) {
		printf("error: int32MaxValue <= int32MinValue\n");
		return false;
	}

	if (INT32_MAX_VALUE_PLUS_ONE != (const int32_t)INT32_MIN) {
		printf("error: int32MaxValuePlusOne != int32MinValue\n");
		return false;
	}

	if (INT32_MIN_VALUE_MINUS_ONE != (const int32_t)INT32_MAX) {
		printf("error: int32MinValueMinusOne != int32MaxValue\n");
		return false;
	}

	printf("passed: Int32 test\n");
	return true;
}


static bool testInt64Static(void) {
	if (INT64_MIN >= 0) {
		printf("error: int64MinValue >= 0\n");
		return false;
	}

	if (INT64_MAX <= 0) {
		printf("error: int64MaxValue <= 0\n");
		return false;
	}

	if (INT64_MAX <= INT64_MIN) {
		printf("error: int64MaxValue <= int64MinValue\n");
		return false;
	}

	if (INT64_MAX_VALUE_PLUS_ONE != (const int64_t)INT64_MIN) {
		printf("error: int64MaxValuePlusOne != int64MinValue\n");
		return false;
	}

	if (INT64_MIN_VALUE_MINUS_ONE != (const int64_t)INT64_MAX) {
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

	bool success = true;

	// test built-in generic types
	success = success && testInteger();
	success = success && testRational();

	// test built-in unsigned integer types
	success = success && testNat8Static();
	success = success && testNat16Static();
	success = success && testNat32Static();
	success = success && testNat64Static();

	// test built-in signed integer types
	success = success && testInt8Static();
	success = success && testInt16Static();
	success = success && testInt32Static();
	success = success && testInt64Static();

	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


