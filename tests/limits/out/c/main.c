
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>



#define _INT8_MIN  (-128)
#define _INT8_MAX  127

#define _INT16_MIN  (-32768)
#define _INT16_MAX  32767

#define _INT32_MIN  (-2147483648UL)
#define _INT32_MAX  2147483647

#define _INT64_MIN  (-9223372036854775808UL)
#define _INT64_MAX  9223372036854775807UL

#define _NAT8_MAX  255
#define _NAT16_MAX  65535
#define _NAT32_MAX  4294967295UL
#define _NAT64_MAX  18446744073709551615UL

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

static void assert(bool cond, char *msg) {
	if (!cond) {
		printf("ASSERT FAILED: %s\n", msg);
		abort();
	}
}


// ------------------------------------------------------------
// Signed integers
// ------------------------------------------------------------

static void testInt8(void) {
	const int8_t min = (int8_t)-128;
	const int8_t max = 127;

	assert(min < 0, "Int8 min < 0");
	assert(max > 0, "Int8 max > 0");

	assert((int8_t)-1 < 0, "Int8 sign");
	assert(1 > 0, "Int8 positive");

	assert(((const int8_t)(max + 1)) == min, "Int8 overflow up");
	assert(((const int8_t)(min - 1)) == max, "Int8 overflow down");
}


static void testInt16(void) {
	const int16_t min = (int16_t)-32768;
	const int16_t max = 32767;

	assert(min < 0, "Int16 min < 0");
	assert(max > 0, "Int16 max > 0");

	assert(((const int16_t)(max + 1)) == min, "Int16 overflow up");
	assert(((const int16_t)(min - 1)) == max, "Int16 overflow down");
}


static void testInt32(void) {
	const int32_t min = (int32_t)-2147483648UL;
	const int32_t max = 2147483647;

	assert(min < 0, "Int32 min < 0");
	assert(max > 0, "Int32 max > 0");

	assert((max + 1) == min, "Int32 overflow up");
	assert((min - 1) == max, "Int32 overflow down");
}


static void testInt64(void) {
	const int64_t min = (int64_t)-9223372036854775808UL;
	const int64_t max = 9223372036854775807L;

	assert(min < 0, "Int64 min < 0");
	assert(max > 0, "Int64 max > 0");

	assert((max + 1) == min, "Int64 overflow up");
	assert((min - 1) == max, "Int64 overflow down");
}


// ------------------------------------------------------------
// Unsigned integers
// ------------------------------------------------------------

static void testNat8(void) {
	const uint8_t max = 255;

	assert(((const uint8_t)(max + 1)) == 0, "Nat8 overflow up");
}


static void testNat16(void) {
	const uint16_t max = 65535;

	assert(((const uint16_t)(max + 1)) == 0, "Nat16 overflow up");
}


static void testNat32(void) {
	const uint32_t max = 4294967295UL;

	assert((max + 1) == 0, "Nat32 overflow up");
}


static void testNat64(void) {
	const uint64_t max = 18446744073709551615UL;

	assert((max + 1) == 0, "Nat64 overflow up");
}


// ------------------------------------------------------------
// Float32
// ------------------------------------------------------------

static void testFloat32(void) {

	const float zero = .0;
	const float one = 1.0;
	const float minus_one = (float)-1.0;

	assert(one > zero, "Float32 positive");
	assert(minus_one < zero, "Float32 negative");

	// Проверка деления
	assert(one / one == one, "Float32 division");

	// Infinity
	const float inf = one / zero;
	assert(inf > one, "Float32 +inf");

	// NaN
	const float nan = zero / zero;
	assert(!(nan == nan), "Float32 NaN");
}


// ------------------------------------------------------------
// Float64
// ------------------------------------------------------------

static void testFloat64(void) {

	const double zero = .0;
	const double one = 1.0;

	const double inf = one / zero;
	assert(inf > one, "Float64 +inf");

	const double nan = zero / zero;
	assert(!(nan == nan), "Float64 NaN");
}


// ------------------------------------------------------------
// Entry
// ------------------------------------------------------------

int32_t main(void) {
	printf("numeric boundary tests\n");

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

	testInt8();
	testInt16();
	testInt32();
	testInt64();

	testNat8();
	testNat16();
	testNat32();
	testNat64();

	testFloat32();
	testFloat64();

	printf("OK\n");

	return 0;
}


