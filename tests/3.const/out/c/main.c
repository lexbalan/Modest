
#include "main.h"

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

#define PS  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}

#define POINTS  (Point[3])PS

__attribute__((used))
static Point points2[3] = POINTS;

// define function main
int main(void) {
	printf("test const\n");

	printf("genericIntConst = %d\n", (int32_t)GENERIC_INT_CONST);
	printf("int32Const = %d\n", INT32_CONST);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", STRING8_CONST);

	return 0;
}


