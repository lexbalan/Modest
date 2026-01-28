
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include <uchar.h>
#else
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#endif
#define __STR_UNICODE__
#define __STR8(x)  x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x)  __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#define _CHR8(x)  (__STR8(x)[0])
#define _CHR16(x) (__STR16(x)[0])
#define _CHR32(x) (__STR32(x)[0])
#endif /* __STR_UNICODE__ */




#define GENERIC_INT_CONST  42
#define INT32_CONST  ((int32_t)GENERIC_INT_CONST)

#define GENERIC_STRING_CONST  "Hello!"
#define STRING8_CONST  (GENERIC_STRING_CONST)
#define STRING16_CONST  (_STR16(GENERIC_STRING_CONST))
#define STRING32_CONST  (_STR32(GENERIC_STRING_CONST))

struct Point {
	uint32_t x;
	uint32_t y;
};
typedef struct Point Point;

struct X {
	Point p;
	Point a[2];
};
typedef struct X X;

#define PS  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}

#define POINTS  PS

#define POINT_ZERO  (Point){.x = 1, .y = 1}
#define ZERO_POINTS  {POINT_ZERO, POINT_ZERO, POINT_ZERO}

static X x = (X){
	.p = (Point){.x = 10, .y = 20},
	.a = {(Point){.x = 20, .y = 30}, (Point){.x = 20, .y = 30}}
};

__attribute__((used))
static Point points2[3] = POINTS;


// define function main
int main(void) {
	printf(/*4*/"test const\n");

	X y = (X){
		.p = (Point){.x = 10, .y = 20},
		.a = {(Point){.x = 20, .y = 30}}
	};

	Point points3[3] = POINTS;

	const Point pp = ((Point[3])POINTS)[0];
	const Point ppp = ((Point[3])ZERO_POINTS)[0];
	const uint32_t z = POINT_ZERO.x;

	printf(/*4*/"genericIntConst = %d\n", (int32_t)GENERIC_INT_CONST);
	printf(/*4*/"int32Const = %d\n", INT32_CONST);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf(/*4*/"string8Const = %s\n", /*4*/(char*)STRING8_CONST);

	return 0;
}


