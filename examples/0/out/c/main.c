
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
__attribute__((used))
static inline __fixed32 __fixed32_from_int32(int32_t a, uint8_t fraction) {
	return (__fixed32)(a * ((int32_t)1 << fraction));
}
__attribute__((used))
static inline __fixed64 __fixed64_from_int64(int64_t a, uint8_t fraction) {
	return (__fixed64)(a * ((int64_t)1 << fraction));
}
__attribute__((used))
static inline int64_t __fixed_rescale(int64_t a, uint8_t from_fraction, uint8_t to_fraction) {
	if (to_fraction >= from_fraction) {
		return a << (to_fraction - from_fraction);
	} else {
		int64_t d = (int64_t)1 << (from_fraction - to_fraction);
		int64_t half = d / 2;
		return (a < 0 ? a - half : a + half) / d;
	}
}
__attribute__((used))
static inline __fixed32 __fixed32_from_float64(double a, uint8_t fraction) {
	return FIXED32(a, fraction);
}
__attribute__((used))
static inline __fixed64 __fixed64_from_float64(double a, uint8_t fraction) {
	return FIXED64(a, fraction);
}
#define __FIXED32_TO_INT32(x, f) ((int32_t)((x) / ((int64_t)1 << (f))))
#define __FIXED64_TO_INT64(x, f) ((int64_t)((x) / ((int64_t)1 << (f))))
#define __FIXED32_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))
#define __FIXED64_TO_FLOAT64(x, f) ((double)(x) / (double)((int64_t)1 << (f)))
__attribute__((used))
static inline int32_t __fixed32_to_int32(__fixed32 a, uint8_t fraction) {
	return (int32_t)(a / ((int64_t)1 << fraction));
}
__attribute__((used))
static inline int64_t __fixed64_to_int64(__fixed64 a, uint8_t fraction) {
	return a / ((int64_t)1 << fraction);
}
__attribute__((used))
static inline double __fixed32_to_float64(__fixed32 a, uint8_t fraction) {
	return (double)a / (double)((int64_t)1 << fraction);
}
__attribute__((used))
static inline double __fixed64_to_float64(__fixed64 a, uint8_t fraction) {
	return (double)a / (double)((int64_t)1 << fraction);
}
#define __FIXED32_MUL(a, b, f) \
	((__fixed32)(((int64_t)(a) * (int64_t)(b) < 0 \
		? (int64_t)(a) * (int64_t)(b) - (((int64_t)1 << (f)) / 2) \
		: (int64_t)(a) * (int64_t)(b) + (((int64_t)1 << (f)) / 2)) \
	/ ((int64_t)1 << (f))))
#define __FIXED32_DIV(a, b, f) \
	((__fixed32)((((a) < 0) == ((b) < 0) \
		? (int64_t)(a) * ((int64_t)1 << (f)) + (int64_t)(b) / 2 \
		: (int64_t)(a) * ((int64_t)1 << (f)) - (int64_t)(b) / 2) \
	/ (int64_t)(b)))
static inline __fixed32 __fixed32_mul(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t p = (int64_t)a * (int64_t)b;
	int64_t scale = (int64_t)1 << fraction;
	return (__fixed32)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);
}
static inline __fixed32 __fixed32_div(__fixed32 a, __fixed32 b, uint8_t fraction) {
	int64_t n = (int64_t)a * ((int64_t)1 << fraction);
	int64_t half = (int64_t)b / 2;
	return (__fixed32)(((a < 0) == (b < 0) ? n + half : n - half) / (int64_t)b);
}
#ifdef __SIZEOF_INT128__
#define __FIXED64_MUL(a, b, f) \
	((__fixed64)(((__int128)(a) * (__int128)(b) < 0 \
		? (__int128)(a) * (__int128)(b) - (((__int128)1 << (f)) / 2) \
		: (__int128)(a) * (__int128)(b) + (((__int128)1 << (f)) / 2)) \
	/ ((__int128)1 << (f))))
#define __FIXED64_DIV(a, b, f) \
	((__fixed64)((((a) < 0) == ((b) < 0) \
		? (__int128)(a) * ((__int128)1 << (f)) + (__int128)(b) / 2 \
		: (__int128)(a) * ((__int128)1 << (f)) - (__int128)(b) / 2) \
	/ (__int128)(b)))
static inline __fixed64 __fixed64_mul(__fixed64 a, __fixed64 b, uint8_t fraction) {
	__int128 p = (__int128)a * (__int128)b;
	__int128 scale = (__int128)1 << fraction;
	return (__fixed64)((p < 0 ? p - scale / 2 : p + scale / 2) / scale);
}
static inline __fixed64 __fixed64_div(__fixed64 a, __fixed64 b, uint8_t fraction) {
	__int128 n = (__int128)a * ((__int128)1 << fraction);
	__int128 half = (__int128)b / 2;
	return (__fixed64)(((a < 0) == (b < 0) ? n + half : n - half) / (__int128)b);
}
#endif /* __SIZEOF_INT128__ */
#endif /* __FIXED_POINT__ */

union range {__fixed32 begin; __fixed32 end;};
struct wrap {union range r;};
static struct wrap x[1] = {
	(struct wrap){.r = (union range){.begin = FIXED32(2.14, 16)}}
};

int main(void) {
	int32_t a = 0;
	printf("Hello World!\n");
	return 0;
}

