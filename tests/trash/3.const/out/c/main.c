
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
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
#define MAIN_GENERIC_INT_CONST 42
#define MAIN_INT32_CONST ((int32_t)MAIN_GENERIC_INT_CONST)
#define MAIN_GENERIC_STRING_CONST "Hello!"
#define MAIN_STRING8_CONST MAIN_GENERIC_STRING_CONST
#define MAIN_STRING16_CONST (_STR16(MAIN_GENERIC_STRING_CONST))
#define MAIN_STRING32_CONST (_STR32(MAIN_GENERIC_STRING_CONST))
struct main_point {
	uint32_t x;
	uint32_t y;
};
struct main_x {
	struct main_point p;
	struct main_point a[2];
};
#define MAIN_PS { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}
#define MAIN_POINTS { \
	(struct main_point){.x = 0, .y = 0}, \
	(struct main_point){.x = 1, .y = 1}, \
	(struct main_point){.x = 2, .y = 2} \
}
#define MAIN_POINT_ZERO ((struct main_point){.x = 1, .y = 1})
#define MAIN_ZERO_POINTS {MAIN_POINT_ZERO, MAIN_POINT_ZERO, MAIN_POINT_ZERO}
static struct main_x main_x = (struct main_x){
	.p = (struct main_point){.x = 10, .y = 20},
	.a = {(struct main_point){.x = 20, .y = 30}, (struct main_point){.x = 20, .y = 30}}
};
__attribute__((used))
static struct main_point main_points2[3] = MAIN_POINTS;

int main(void) {
	printf("test const\n");
	struct main_x y = (struct main_x){
		.p = (struct main_point){.x = 10, .y = 20},
		.a = {(struct main_point){.x = 20, .y = 30}}
	};
	struct main_point points3[3] = MAIN_POINTS;
	const struct main_point pp = ((const struct main_point [3])MAIN_POINTS)[0];
	const struct main_point ppp = ((const struct main_point [3])MAIN_ZERO_POINTS)[0];
	const uint32_t z = MAIN_POINT_ZERO.x;
	printf("genericIntConst = %d\n", (int32_t)MAIN_GENERIC_INT_CONST);
	printf("int32Const = %d\n", MAIN_INT32_CONST);
	printf("string8Const = %s\n", MAIN_STRING8_CONST);
	return 0;
}

