
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#define _NAT8_MAX_VALUE ((uint8_t)UINT8_MAX)
#define _NAT8_MIN_VALUE ((uint8_t)0)
#define _NAT16_MAX_VALUE ((uint16_t)UINT16_MAX)
#define _NAT16_MIN_VALUE ((uint16_t)0)
#define _NAT32_MAX_VALUE ((uint32_t)UINT32_MAX)
#define _NAT32_MIN_VALUE ((uint32_t)0)
#define _NAT64_MAX_VALUE ((uint64_t)UINT64_MAX)
#define _NAT64_MIN_VALUE ((uint64_t)0)
#define _INT8_MAX_VALUE ((int8_t)INT8_MAX)
#define _INT8_MIN_VALUE ((int8_t)INT8_MIN)
#define _INT16_MAX_VALUE ((int16_t)INT16_MAX)
#define _INT16_MIN_VALUE ((int16_t)INT16_MIN)
#define _INT32_MAX_VALUE ((int32_t)INT32_MAX)
#define _INT32_MIN_VALUE ((int32_t)INT32_MIN)
#define _INT64_MAX_VALUE ((int64_t)INT64_MAX)
#define _INT64_MIN_VALUE ((int64_t)INT64_MIN)

static bool testNat8Static(void) {
	uint8_t nat8;
	nat8 = UINT8_MAX;
	nat8 = 0;
	uint8_t _nat8MaxValue = UINT8_MAX;
	uint8_t _nat8MinValue = 0;
	if (_nat8MaxValue <= _nat8MinValue) {
		printf("error: nat8MaxValue <= nat8MinValue\n");
		return false;
	}
	if (_nat8MaxValue + 1 != _nat8MinValue) {
		printf("error: nat8MaxValuePlusOne != nat8MinValue\n");
		return false;
	}
	if (_nat8MinValue - 1 != _nat8MaxValue) {
		printf("error: nat8MinValueMinusOne != nat8MaxValue\n");
		return false;
	}
	printf("passed: Nat8 test\n");
	return true;
}

static bool testNat16Static(void) {
	uint16_t nat16;
	nat16 = UINT16_MAX;
	nat16 = 0;
	uint16_t _nat16MinValue = 0;
	uint16_t _nat16MaxValue = UINT16_MAX;
	if (_nat16MaxValue <= _nat16MinValue) {
		printf("error: nat16MaxValue <= nat16MinValue\n");
		return false;
	}
	if (_nat16MaxValue + 1 != _nat16MinValue) {
		printf("error: nat16MaxValuePlusOne != nat16MinValue\n");
		return false;
	}
	if (_nat16MinValue - 1 != _nat16MaxValue) {
		printf("error: nat16MinValueMinusOne != nat16MaxValue\n");
		return false;
	}
	printf("passed: Nat16 test\n");
	return true;
}

static bool testNat32Static(void) {
	uint32_t nat32;
	nat32 = UINT32_MAX;
	nat32 = 0;
	uint32_t _nat32MaxValue = UINT32_MAX;
	uint32_t _nat32MinValue = 0;
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
	nat64 = UINT64_MAX;
	nat64 = 0;
	uint64_t _nat64MaxValue = UINT64_MAX;
	uint64_t _nat64MinValue = 0;
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
	int8 = INT8_MAX;
	int8 = INT8_MIN;
	int8_t _int8MinValue = INT8_MIN;
	int8_t _int8MaxValue = INT8_MAX;
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
	if (_int8MaxValue + 1 != _int8MinValue) {
		printf("error: int8MaxValuePlusOne != int8MinValue\n");
		return false;
	}
	if (_int8MinValue - 1 != _int8MaxValue) {
		printf("error: int8MinValueMinusOne != int8MaxValue\n");
		return false;
	}
	printf("passed: Int8 test\n");
	return true;
}

static bool testInt16Static(void) {
	int16_t int16;
	int16 = INT16_MAX;
	int16 = INT16_MIN;
	int16_t _int16MinValue = INT16_MIN;
	int16_t _int16MaxValue = INT16_MAX;
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
	if (_int16MaxValue + 1 != _int16MinValue) {
		printf("error: int16MaxValuePlusOne != int16MinValue\n");
		return false;
	}
	if (_int16MinValue - 1 != _int16MaxValue) {
		printf("error: int16MinValueMinusOne != int16MaxValue\n");
		return false;
	}
	printf("passed: Int16 test\n");
	return true;
}

static bool testInt32Static(void) {
	int32_t int32;
	int32 = INT32_MAX;
	int32 = INT32_MIN;
	int32_t _int32MinValue = INT32_MIN;
	int32_t _int32MaxValue = INT32_MAX;
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
	int64_t _int64MinValue = INT64_MIN;
	int64_t _int64MaxValue = INT64_MAX;
	int64_t int64;
	int64 = INT64_MAX;
	int64 = INT64_MIN;
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

static bool testFloat32Static(void) {
	float a = 3.0;
	float b = 2.0;
	if (a + b != 5.0) {
		printf("3.0 + 2.0 != 5.0 (=%f)\n", a + b);
		return false;
	}
	if (a - b != 1.0) {
		printf("3.0 - 2.0 != 1.0 (=%f)\n", a - b);
		return false;
	}
	if (a * b != 6.0) {
		printf("3.0 * 2.0 != 6.0 (=%f)\n", a * b);
		return false;
	}
	if (a / b != 1.5) {
		printf("3.0 / 2.0 != 1.5 (=%f)\n", a / b);
		return false;
	}
	return true;
}

static bool testInteger(void) {
	printf("passed: Integer test\n");
	return true;
}

static bool testRational(void) {
	const double pi = 3.14;
	if (pi != 3.14) {
		printf("error: pi != 3.14\n");
		return false;
	}
	const int npi = (int)pi;
	if (npi != 3) {
		printf("%d", (int32_t)npi);
		printf("error: npi != 3\n");
		return false;
	}
	printf("passed: Rational test\n");
	return true;
}

int32_t main(void) {
	printf("test numeric boundary:\n");
	bool result;
	bool success = true;
	result = testInteger();
	success = success && result;
	result = testRational();
	success = success && result;
	result = testNat8Static();
	success = success && result;
	result = testNat16Static();
	success = success && result;
	result = testNat32Static();
	success = success && result;
	result = testNat64Static();
	success = success && result;
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
