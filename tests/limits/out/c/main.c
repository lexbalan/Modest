
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
//const float32PosInf    = Float32 (1.0 / 0.0)
//const float32NaN       = Float32 (0.0 / 0.0)
//const float32NegInf    = Float32 (-1.0 / 0.0)

/*

func assert(cond: Bool, msg: *Str8) {
    if not cond {
        printf("ASSERT FAILED: %s\n", msg)
        abort()
    }
}


// ------------------------------------------------------------
// Signed integers
// ------------------------------------------------------------

func test_Int8 () -> Unit {
    let min = Int8 -128
    let max = Int8 127

    assert(min < Int8 0, "Int8 min < 0")
    assert(max > Int8 0, "Int8 max > 0")

    assert(Int8 -1 < Int8 0, "Int8 sign")
    assert(Int8 1 > Int8 0, "Int8 positive")

    // wrap tests (если у тебя defined wrap semantics)
//	printf("?? = %lld\n", Int64 (max + Int8 1))
    assert(Int8 (max + Int8 1) == min, "Int8 overflow up")
    assert(Int8 (min - Int8 1) == max, "Int8 overflow down")
}


func test_Int16 () -> Unit {
    let min = Int16 -32768
    let max = Int16 32767

    assert(Int16 (max + Int16 1) == min, "Int16 overflow up")
    assert(Int16 (min - Int16 1) == max, "Int16 overflow down")
}


func test_Int32 () -> Unit {
    let min = Int32 -2147483648
    let max = Int32 2147483647

    assert(Int32 (max + Int32 1) == min, "Int32 overflow up")
    assert(Int32 (min - Int32 1) == max, "Int32 overflow down")
}


func test_Int64 () -> Unit {
    let min = Int64 -9223372036854775808
    let max = Int64 9223372036854775807

    assert(Int64 (max + Int64 1) == min, "Int64 overflow up")
    assert(Int64 (min - Int64 1) == max, "Int64 overflow down")
}


// ------------------------------------------------------------
// Unsigned integers
// ------------------------------------------------------------

func test_Nat8 () -> Unit {
    let max = Nat8 255

    assert(Nat8 0 == Nat8 (max + Nat8 1), "Nat8 overflow up")
}

func test_Nat16 () -> Unit {
    let max = Nat16 65535

    assert(Nat16 0 == Nat16 (max + Nat16 1), "Nat16 overflow up")
}

func test_Nat32 () -> Unit {
    let max = Nat32 4294967295

    assert(Nat32 0 == Nat32 (max + Nat32 1), "Nat32 overflow up")
}

func test_Nat64 () -> Unit {
    let max = Nat64 18446744073709551615

    assert(Nat64 0 == Nat64 (max + Nat64 1), "Nat64 overflow up")
}


// ------------------------------------------------------------
// Float32
// ------------------------------------------------------------

func test_Float32 () -> Unit {

    let zero = Float32 0.0
    let one = Float32 1.0
    let minus_one = Float32 -1.0

    assert(one > zero, "Float32 positive")
    assert(minus_one < zero, "Float32 negative")

    // Проверка деления
    assert(one / one == one, "Float32 division")

    // Infinity
//    let inf = one / zero
//    assert(inf > one, "Float32 +inf")
//
//    // NaN
//    let nan = zero / zero
//    assert(not(nan == nan), "Float32 NaN")
}


// ------------------------------------------------------------
// Float64
// ------------------------------------------------------------

func test_Float64 () -> Unit {

    let zero = Float64 0.0
    let one = Float64 1.0

//    let inf = one / zero
//    assert(inf > one, "Float64 +inf")
//
//    let nan = zero / zero
//    assert(not(nan == nan), "Float64 NaN")
}

*/

// ------------------------------------------------------------
// Entry
// ------------------------------------------------------------

int32_t main(void) {
	printf("numeric boundary tests\n");

	#define f  3.1415926535897932384626433832795028841971693993751058209749445923
	float f32 = (float)f;
	double f64 = (double)f;

	printf("f32 = %.9g\n", f32);
	printf("f64 = %.17g\n", f64);

	//	if f32 == 3.14 {
	//		printf("ok1\n")
	//	}

	if (f64 == 3.1415926535897931) {
		printf("ok2\n");
	}

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

	//    test_Int8()
	//    test_Int16()
	//    test_Int32()
	//    test_Int64()
	//
	//    test_Nat8()
	//    test_Nat16()
	//    test_Nat32()
	//    test_Nat64()
	//
	//    test_Float32()
	//    test_Float64()
	//
	//    printf("OK\n")
	return 0;

#undef f
}


