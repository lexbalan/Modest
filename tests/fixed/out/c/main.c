
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef __FIXED_POINT__
typedef int32_t __fixed32;
typedef int64_t __fixed64;
static inline __fixed64 __fixed64_create(int64_t i, uint64_t m, uint64_t n, uint8_t fraction) {
	return (i << fraction) | (m * (1 << fraction) / n);
}
static inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {
	return a * (1 << fraction);
}
__attribute__((used))
static inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {
	return (__fixed32)(a * (1 << fraction));
}
static inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {
	return a / (1 << fraction);
}
static inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {
	return (double)a / (1 << fraction);
}
static inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {
	return (__fixed32)(((int64_t)a * (int64_t)b) >> fraction);
}
static inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {
	return (__fixed32)(((int64_t)a << fraction) / (int64_t)b);
}
#endif /* __FIXED_POINT__ */



// fx = i + m/n
static int32_t packFixed32(uint32_t i, uint32_t m, uint32_t n, uint8_t fraction) {
	const uint64_t tail = (uint64_t)m * ((uint64_t)(0x1 << fraction) - 1) / (uint64_t)n;
	return (int32_t)((i << fraction) | (uint32_t)tail);
}



// just returns head as is
static uint32_t headFixed32(uint32_t f, uint8_t fraction) {
	return (f >> fraction);
}



// just returns tail as is
static uint32_t tailFixed32(uint32_t f, uint8_t fraction) {
	const uint32_t mask = ((0x1 << fraction) - 1);
	return (f & mask);
}



// precision = 10 ... 1000000 - number of zeroes = number of digits in output value
static void printFixed32(uint32_t f, uint8_t fraction, uint32_t precision) {
	const uint32_t h = headFixed32(f, fraction);
	const uint32_t t = tailFixed32(f, fraction);
	const uint32_t tail = (uint32_t)((uint64_t)t * (uint64_t)precision / (uint64_t)(0x1 << fraction));
	printf("%d.%d", h, tail);
}


static bool testFixed32Static(void) {
	static uint32_t st;

	int32_t f;

	f = __fixed64_create(3, 141592, 1000000, 18);

	const int32_t a = f + __fixed32_from_int32(1, 18);
	const int32_t b = f - __fixed32_from_int32(1, 18);
	const int32_t c = __fixed32_mul(f, __fixed32_from_int32(2, 18), 18);
	const int32_t d = __fixed32_div(f, __fixed32_from_int32(2, 18), 18);

	printf("fx = ");
	printFixed32((uint32_t)f, 18, 1000000);
	printf("\n");

	const int32_t f2 = packFixed32(3, 1415926, 10000000, 20);
	printf("f2 = ");
	printFixed32((uint32_t)f2, 20, 10000000);
	printf("\n");

	printf("Raw f = %d\n", f);
	printf("Raw a = %d\n", a);
	printf("Raw b = %d\n", b);
	printf("Raw c = %d\n", c);
	printf("Raw d = %d\n", d);

	printf("Int32 f = %d\n", __fixed32_to_int32(f, 18));
	printf("Int32 a = %d\n", __fixed32_to_int32(a, 18));
	printf("Int32 b = %d\n", __fixed32_to_int32(b, 18));
	printf("Int32 c = %d\n", __fixed32_to_int32(c, 18));
	printf("Int32 d = %d\n", __fixed32_to_int32(d, 18));

	printf("Float32 f = %f\n", __fixed32_to_float64(f, 18));
	printf("Float32 a = %f\n", __fixed32_to_float64(a, 18));
	printf("Float32 b = %f\n", __fixed32_to_float64(b, 18));
	printf("Float32 c = %f\n", __fixed32_to_float64(c, 18));
	printf("Float32 d = %f\n", __fixed32_to_float64(d, 18));

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


