
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#ifndef __FIXED_POINT__
typedef int32_t __fixed32;
typedef int64_t __fixed64;
#define FIXED32(x, f) ((__fixed32)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))
#define FIXED64(x, f) ((__fixed64)((double)(x) * (double)((int64_t)1 << (f)) + ((x) < 0 ? -0.5 : 0.5)))
static inline __fixed64 __fixed64_create(int64_t i, uint64_t m, uint64_t n, uint8_t fraction) {
	return (i << fraction) | (m * (1 << fraction) / n);
}
static inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {
	return a * (1 << fraction);
}
__attribute__((used))
static inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {
	return FIXED32(a, fraction);
}
__attribute__((used))
static inline __fixed64 __fixed64_from_float64(double a, uint8_t fraction) {
	return FIXED64(a, fraction);
}
static inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {
	return a / (1 << fraction);
}
static inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {
	return (double)a / (1 << fraction);
}
static inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t p = (int64_t)a * (int64_t)b;
	int64_t half = (int64_t)1 << (fraction - 1);
	return (__fixed32)((p < 0 ? p - half : p + half) >> fraction);
}
static inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t n = (int64_t)a << fraction;
	int64_t half = (int64_t)b / 2;
	return (__fixed32)(((n < 0) == (b < 0) ? n + half : n - half) / (int64_t)b);
}
#endif /* __FIXED_POINT__ */

static float f32 = 0.0;
static double f64 = 0.0;
static int32_t fx32 = FIXED32(0.0, 16);
static int64_t fx64 = FIXED64(0.0, 32);
#define C 1.5
static int64_t arr[10] = {FIXED64(1.5, 32), FIXED64(2.5, 32)};


int main(void) {
	printf("Hello World!\n");
	f32 = (float)1.0;
	f64 = 1.0;
	fx32 = FIXED32(1, 16);
	fx64 = FIXED64(1, 32);
	printf("fx32 = 0x%08x\n", fx32);
	printf("fx64 = 0x%016llx\n", fx64);
	fx32 = FIXED32(C, 16);
	fx64 = FIXED64(C, 32);
	printf("fx32 = 0x%08x\n", fx32);
	printf("fx64 = 0x%016llx\n", fx64);
	const int32_t c2 = FIXED32(1.5, 16);
	const int32_t c3 = 49152;
	printf("c3 = 0x%08x\n", c3);
	return 0;
}

