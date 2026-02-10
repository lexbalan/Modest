
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef __BIG_INT128__
#define BIG_INT128(hi64, lo64) (((__int128)(hi64) << 64) | ((__int128)(lo64)))
static inline __int128 abs128(__int128 x) {return x < 0 ? -x : x;}
#endif  /* __BIG_INT128__ */

#ifndef __BIG_INT256__
#define BIG_INT256(a, b, c, d)
#endif  /* __BIG_INT256__ */



#define INT8_MIN_VALUE  (-128)
#define INT8_MAX_VALUE  127

#define INT16_MIN_VALUE  (-32768)
#define INT16_MAX_VALUE  32767

#define INT32_MIN_VALUE  (-2147483648UL)
#define INT32_MAX_VALUE  2147483647

#define INT64_MIN_VALUE  (-9223372036854775808UL)
#define INT64_MAX_VALUE  9223372036854775807UL

#define INT128_MIN_VALUE  (-BIG_INT128(0x8000000000000000ULL, 0x0ULL))
#define INT128_MAX_VALUE  BIG_INT128(0x7FFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)

#define NAT8_MIN_VALUE  0
#define NAT8_MAX_VALUE  255

#define NAT16_MIN_VALUE  0
#define NAT16_MAX_VALUE  65535

#define NAT32_MIN_VALUE  0
#define NAT32_MAX_VALUE  4294967295UL

#define NAT64_MIN_VALUE  0
#define NAT64_MAX_VALUE  18446744073709551615UL

#define NAT128_MIN_VALUE  0
#define NAT128_MAX_VALUE  BIG_INT128(0xFFFFFFFFFFFFFFFFULL, 0xFFFFFFFFFFFFFFFFULL)

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

#define NAT8_MAX_VALUE_PLUS_ONE  ((uint8_t)NAT8_MAX_VALUE + 1)
#define NAT8_MIN_VALUE_MINUS_ONE  ((uint8_t)NAT8_MIN_VALUE - 1)
#define NAT16_MAX_VALUE_PLUS_ONE  ((uint16_t)NAT16_MAX_VALUE + 1)
#define NAT16_MIN_VALUE_MINUS_ONE  ((uint16_t)NAT16_MIN_VALUE - 1)
#define NAT32_MAX_VALUE_PLUS_ONE  ((uint32_t)NAT32_MAX_VALUE + 1)
#define NAT32_MIN_VALUE_MINUS_ONE  ((uint32_t)NAT32_MIN_VALUE - 1)
#define NAT64_MAX_VALUE_PLUS_ONE  ((uint64_t)NAT64_MAX_VALUE + 1)
#define NAT64_MIN_VALUE_MINUS_ONE  ((uint64_t)NAT64_MIN_VALUE - 1)

#define INT8_MAX_VALUE_PLUS_ONE  ((int8_t)INT8_MAX_VALUE + 1)
#define INT8_MIN_VALUE_MINUS_ONE  ((int8_t)INT8_MIN_VALUE - 1)
#define INT16_MAX_VALUE_PLUS_ONE  ((int16_t)INT16_MAX_VALUE + 1)
#define INT16_MIN_VALUE_MINUS_ONE  ((int16_t)INT16_MIN_VALUE - 1)
#define INT32_MAX_VALUE_PLUS_ONE  ((int32_t)INT32_MAX_VALUE + 1)
#define INT32_MIN_VALUE_MINUS_ONE  ((int32_t)INT32_MIN_VALUE - 1)
#define INT64_MAX_VALUE_PLUS_ONE  ((int64_t)INT64_MAX_VALUE + 1)
#define INT64_MIN_VALUE_MINUS_ONE  ((int64_t)INT64_MIN_VALUE - 1)

static bool testNat8Static(void) {
	if (NAT8_MAX_VALUE <= NAT8_MIN_VALUE) {
		printf("error: nat8MaxValue <= nat8MinValue\n");
		return false;
	}

	if (NAT8_MAX_VALUE_PLUS_ONE != (const uint8_t)NAT8_MIN_VALUE) {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n");
		return false;
	}

	if (NAT8_MIN_VALUE_MINUS_ONE != (const uint8_t)NAT8_MAX_VALUE) {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n");
		return false;
	}

	printf("passed: Nat8 test\n");
	return true;
}


static bool testNat16Static(void) {
	if (NAT16_MAX_VALUE <= (const int16_t)NAT16_MIN_VALUE) {
		printf("error: nat16MaxValue <= nat16MinValue\n");
		return false;
	}

	if (NAT16_MAX_VALUE_PLUS_ONE != (const uint16_t)NAT16_MIN_VALUE) {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n");
		return false;
	}

	if (NAT16_MIN_VALUE_MINUS_ONE != (const uint16_t)NAT16_MAX_VALUE) {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n");
		return false;
	}

	printf("passed: Nat16 test\n");
	return true;
}


static bool testNat32Static(void) {
	if (NAT32_MAX_VALUE <= (const int32_t)NAT32_MIN_VALUE) {
		printf("error: nat32MaxValue <= nat32MinValue\n");
		return false;
	}

	if (NAT32_MAX_VALUE_PLUS_ONE != (const uint32_t)NAT32_MIN_VALUE) {
		printf("error: nat32MaxValuePlusOne != nat32MinValue\n");
		return false;
	}

	if (NAT32_MIN_VALUE_MINUS_ONE != (const uint32_t)NAT32_MAX_VALUE) {
		printf("error: nat32MinValueMinusOne != nat32MaxValue\n");
		return false;
	}

	printf("passed: Nat32 test\n");
	return true;
}


static bool testNat64Static(void) {
	if (NAT64_MAX_VALUE <= (const int64_t)NAT64_MIN_VALUE) {
		printf("error: nat64MaxValue <= nat64MinValue\n");
		return false;
	}

	if (NAT64_MAX_VALUE_PLUS_ONE != (const uint64_t)NAT64_MIN_VALUE) {
		printf("error: nat64MaxValuePlusOne != nat64MinValue\n");
		return false;
	}

	if (NAT64_MIN_VALUE_MINUS_ONE != (const uint64_t)NAT64_MAX_VALUE) {
		printf("error: nat64MinValueMinusOne != nat64MaxValue\n");
		return false;
	}

	printf("passed: Nat64 test\n");
	return true;
}


static bool testInt8Static(void) {
	if (INT8_MIN_VALUE >= 0) {
		printf("error: int8MinValue >= 0\n");
		return false;
	}

	if (INT8_MAX_VALUE <= 0) {
		printf("error: int8MaxValue <= 0\n");
		return false;
	}

	if (INT8_MAX_VALUE <= INT8_MIN_VALUE) {
		printf("error: int8MaxValue <= int8MinValue\n");
		return false;
	}

	if (INT8_MAX_VALUE_PLUS_ONE != (const int8_t)INT8_MIN_VALUE) {
		printf("error: int8MaxValuePlusOne != int8MinValue\n");
		return false;
	}

	if (INT8_MIN_VALUE_MINUS_ONE != (const int8_t)INT8_MAX_VALUE) {
		printf("error: int8MinValueMinusOne != int8MaxValue\n");
		return false;
	}

	printf("passed: Int8 test\n");
	return true;
}


static bool testInt16Static(void) {
	if (INT16_MIN_VALUE >= 0) {
		printf("error: int16MinValue >= 0\n");
		return false;
	}

	if (INT16_MAX_VALUE <= 0) {
		printf("error: int16MaxValue <= 0\n");
		return false;
	}

	if (INT16_MAX_VALUE <= INT16_MIN_VALUE) {
		printf("error: int16MaxValue <= int16MinValue\n");
		return false;
	}

	if (INT16_MAX_VALUE_PLUS_ONE != (const int16_t)INT16_MIN_VALUE) {
		printf("error: int16MaxValuePlusOne != int16MinValue\n");
		return false;
	}

	if (INT16_MIN_VALUE_MINUS_ONE != (const int16_t)INT16_MAX_VALUE) {
		printf("error: int16MinValueMinusOne != int16MaxValue\n");
		return false;
	}

	printf("passed: Int16 test\n");
	return true;
}


static bool testInt32Static(void) {
	if (INT32_MIN_VALUE >= 0) {
		printf("error: int32MinValue >= 0\n");
		return false;
	}

	if (INT32_MAX_VALUE <= 0) {
		printf("error: int32MaxValue <= 0\n");
		return false;
	}

	if (INT32_MAX_VALUE <= INT32_MIN_VALUE) {
		printf("error: int32MaxValue <= int32MinValue\n");
		return false;
	}

	if (INT32_MAX_VALUE_PLUS_ONE != (const int32_t)INT32_MIN_VALUE) {
		printf("error: int32MaxValuePlusOne != int32MinValue\n");
		return false;
	}

	if (INT32_MIN_VALUE_MINUS_ONE != (const int32_t)INT32_MAX_VALUE) {
		printf("error: int32MinValueMinusOne != int32MaxValue\n");
		return false;
	}

	printf("passed: Int32 test\n");
	return true;
}


static bool testInt64Static(void) {
	if (INT64_MIN_VALUE >= 0) {
		printf("error: int64MinValue >= 0\n");
		return false;
	}

	if (INT64_MAX_VALUE <= 0) {
		printf("error: int64MaxValue <= 0\n");
		return false;
	}

	if (INT64_MAX_VALUE <= INT64_MIN_VALUE) {
		printf("error: int64MaxValue <= int64MinValue\n");
		return false;
	}

	if (INT64_MAX_VALUE_PLUS_ONE != (const int64_t)INT64_MIN_VALUE) {
		printf("error: int64MaxValuePlusOne != int64MinValue\n");
		return false;
	}

	if (INT64_MIN_VALUE_MINUS_ONE != (const int64_t)INT64_MAX_VALUE) {
		printf("error: int64MinValueMinusOne != int64MaxValue\n");
		return false;
	}

	printf("passed: Int64 test\n");
	return true;
}


static void assert(bool x) {
	//
}


int32_t main(void) {
	printf("numeric boundary tests\n");

	assert(testNat8Static());
	assert(testNat16Static());
	assert(testNat32Static());
	assert(testNat64Static());

	assert(testInt8Static());
	assert(testInt16Static());
	assert(testInt32Static());
	assert(testInt64Static());

	printf("OK\n");

	return 0;
}


