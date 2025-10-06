// tests/3.const/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


#define genericIntConst  42
#define int32Const  ((int32_t)genericIntConst)

#define genericStringConst  "Hello!"
#define string8Const  (char *)genericStringConst
#define string16Const  (uint16_t *)genericStringConst
#define string32Const  (uint32_t *)genericStringConst

struct Point {
	uint32_t x;
	uint32_t y;
};
typedef struct Point Point;

#define ps  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}

#define points  (Point[3])ps

static Point points2[3] = {
	{.x = 0, .y = 0},
	{.x = 1, .y = 1},
	{.x = 2, .y = 2}
};

// define function main
int main()
{
	printf("test const\n");

	printf("genericIntConst = %d\n", (int32_t)genericIntConst);
	printf("int32Const = %d\n", int32Const);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const);

	return 0;
}

