
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



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
	printf("test const\n");

	X y = (X){
		.p = (Point){.x = 10, .y = 20},
		.a = {(Point){.x = 20, .y = 30}}
	};

	Point points3[3] = POINTS;

	const Point pp = ((Point[3])POINTS)[0];
	const Point ppp = ((Point[3])ZERO_POINTS)[0];
	const uint32_t z = POINT_ZERO.x;

	printf("genericIntConst = %d\n", (int32_t)GENERIC_INT_CONST);
	printf("int32Const = %d\n", INT32_CONST);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", (char*)STRING8_CONST);

	return 0;
}


