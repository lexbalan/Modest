
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef __FIXED_POINT__
typedef int32_t __fixed32;
typedef int64_t __fixed64;
static inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {
	return a * (1 << fraction);
}
static inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {
	return (__fixed32)(a * (1 << fraction));
}
static inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {
	return a / (1 << fraction);
}
static inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {
	return (float)a / (1 << fraction);
}
static inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {
	return ((int64_t)a * (int64_t)b) >> fraction;
}
static inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {
	return ((int64_t)a << fraction) / (int64_t)b;
}
#endif /* __FIXED_POINT__ */


static bool testFixed32Static(void) {

	//var fx: @fraction(20) Fixed32
	int32_t fx;

	fx = __fixed32_from_float64(3.1415, 16);

	const int32_t a = fx + __fixed32_from_int32(1, 16);
	const int32_t b = fx - __fixed32_from_int32(1, 16);
	const int32_t c = __fixed32_mul(fx, __fixed32_from_int32(2, 16), 16);
	const int32_t d = __fixed32_div(fx, __fixed32_from_int32(2, 16), 16);

	printf("Raw fx = %d\n", fx);
	printf("Raw a = %d\n", a);
	printf("Raw b = %d\n", b);
	printf("Raw c = %d\n", c);
	printf("Raw d = %d\n", d);

	printf("Int32 fx = %d\n", __fixed32_to_int32(fx, 16));
	printf("Int32 a = %d\n", __fixed32_to_int32(a, 16));
	printf("Int32 b = %d\n", __fixed32_to_int32(b, 16));
	printf("Int32 c = %d\n", __fixed32_to_int32(c, 16));
	printf("Int32 d = %d\n", __fixed32_to_int32(d, 16));

	printf("Float32 fx = %f\n", __fixed32_to_float64(fx, 16));
	printf("Float32 a = %f\n", __fixed32_to_float64(a, 16));
	printf("Float32 b = %f\n", __fixed32_to_float64(b, 16));
	printf("Float32 c = %f\n", __fixed32_to_float64(c, 16));
	printf("Float32 d = %f\n", __fixed32_to_float64(d, 16));

	return true;
}


int32_t main(void) {
	printf("test fixed\n");

	const bool success = testFixed32Static();

	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


