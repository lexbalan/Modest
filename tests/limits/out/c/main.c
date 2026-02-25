
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>




// constants check (ok)
#define _NAT8_MAX_VALUE  ((uint8_t)UINT8_MAX)
#define _NAT8_MIN_VALUE  ((uint8_t)0)
#define _NAT16_MAX_VALUE  ((uint16_t)UINT16_MAX)
#define _NAT16_MIN_VALUE  ((uint16_t)0)
#define _NAT32_MAX_VALUE  ((uint32_t)UINT32_MAX)
#define _NAT32_MIN_VALUE  ((uint32_t)0)
#define _NAT64_MAX_VALUE  ((uint64_t)UINT64_MAX)
#define _NAT64_MIN_VALUE  ((uint64_t)0)

#define _INT8_MAX_VALUE  ((int8_t)INT8_MAX)
#define _INT8_MIN_VALUE  ((int8_t)INT8_MIN)
#define _INT16_MAX_VALUE  ((int16_t)INT16_MAX)
#define _INT16_MIN_VALUE  ((int16_t)INT16_MIN)
#define _INT32_MAX_VALUE  ((int32_t)INT32_MAX)
#define _INT32_MIN_VALUE  ((int32_t)INT32_MIN)
#define _INT64_MAX_VALUE  ((int64_t)INT64_MAX)
#define _INT64_MIN_VALUE  ((int64_t)INT64_MIN)

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

static bool testNat8Static(void) {
	uint8_t nat8;
	nat8 =
