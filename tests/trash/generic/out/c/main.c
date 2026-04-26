
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define ARRCPY(dst, src, len) \
	do { \
		uint32_t _len = (uint32_t)(len); \
		for (uint32_t _i = 0; _i < _len; _i++) { \
			(*(dst))[_i] = (*(src))[_i]; \
		} \
	} while (0)
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
static bool main_test_generic_integer(void);
static bool main_test_generic_float(void);
static bool main_test_generic_char(void);
static bool main_test_generic_array(void);
static bool main_test_generic_record(void);

int main(void) {
	printf("generic types test\n");
	const bool main_t1 = main_test_generic_integer();
	if (main_t1) {
		printf("test_generic_integer passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}
	const bool main_t2 = main_test_generic_float();
	if (main_t2) {
		printf("test_generic_float passed\n");
	} else {
		printf("test_generic_float failed\n");
	}
	const bool main_t3 = main_test_generic_char();
	if (main_t3) {
		printf("test_generic_char passed\n");
	} else {
		printf("test_generic_char failed\n");
	}
	const bool main_t4 = main_test_generic_array();
	if (main_t4) {
		printf("test_generic_array passed\n");
	} else {
		printf("test_generic_array failed\n");
	}
	const bool main_t5 = main_test_generic_record();
	if (main_t5) {
		printf("test_generic_record passed\n");
	} else {
		printf("test_generic_integer failed\n");
	}
	return 0;
}

static bool main_test_generic_integer(void) {
	#define main_one 1
	#define main_two (1 + main_one)
	int32_t a = main_one;
	uint64_t b = main_one;
	float f = main_one;
	double g = main_one;
	uint8_t x = (uint8_t)main_one;
	char c = (char)main_one;
	char16_t d = (char16_t)main_one;
	char32_t e = (char32_t)main_one;
	bool k = main_one != 0;
	return true;
	#undef main_one
	#undef main_two
}

static bool main_test_generic_float(void) {
	#define main_pi 3.1415926535897932384626433832795028841971693993751058209749445923
	float f = main_pi;
	double g = main_pi;
	int32_t x = (int32_t)main_pi;
	return true;
	#undef main_pi
}

static bool main_test_generic_char(void) {
	#define main_a "A"
	char b = main_a[0];
	char16_t c = main_a[0];
	char32_t d = main_a[0];
	int32_t char_code = (uint32_t)main_a[0];
	return true;
	#undef main_a
}

static bool main_test_generic_array(void) {
	#define main_a {0, 1, 2, 3}
	uint32_t i = 0U;
	if (__builtin_memcmp(&(const int8_t [4])main_a, &(int8_t [4]){0, 1, 2, 3}, sizeof(const int8_t [4])) != 0) {
		printf("error: a != [0, 1, 2, 3]\n");
		return false;
	}
	int32_t b[4];
	ARRCPY(&b, ((&(const int8_t [4])main_a)), LENGTHOF(b));
	if (__builtin_memcmp(&b, &(int32_t [4]){0, 1, 2, 3}, sizeof(int32_t [4])) != 0) {
		printf("b != [0, 1, 2, 3]\n");
		return false;
	}
	int64_t c[4];
	ARRCPY(&c, ((&(const int8_t [4])main_a)), LENGTHOF(c));
	if (__builtin_memcmp(&c, &(int64_t [4]){0, 1, 2, 3}, sizeof(int64_t [4])) != 0) {
		printf("c != [0, 1, 2, 3]\n");
		return false;
	}
	int32_t d[10] = {0, 1, 2, 3};
	if (__builtin_memcmp(&d, &(int32_t [10]){0, 1, 2, 3, 0, 0, 0, 0, 0, 0}, sizeof(int32_t [10])) != 0) {
		printf("d != [0, 1, 2, 3, 0, 0, 0, 0, 0, 0]\n");
		return false;
	}
	return true;
	#undef main_a
}
struct main_point2_d {
	int32_t x;
	int32_t y;
};
struct main_point3_d {
	int32_t x;
	int32_t y;
	int32_t z;
};

static bool main_test_generic_record(void) {
	#define main_p {.x = 10, .y = 20}
	struct main_point2_d point_2d;
	point_2d = (struct main_point2_d)main_p;
	(void)point_2d;
	struct main_point3_d point_3d;
	point_3d = (struct main_point3_d){.x = 10, .y = 20};
	(void)point_3d;
	return true;
	#undef main_p
}

