// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Point {
	uint32_t x;
	uint32_t y;
};
#define main_genericIntConst  42
#define main_int32Const  ((int32_t)main_genericIntConst)
#define main_genericStringConst  "Hello!"
#define main_string8Const  (char *)main_genericStringConst
#define main_string16Const  u"Hello!"
#define main_string32Const  U"Hello!"
#define _main_ps  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}
const struct {int8_t x; int8_t y;} main_ps[3] = _main_ps;
#define _main_points  _main_ps
const main_Point main_points[3] = _main_points;



static main_Point points2[3] = _main_points;

int main()
{
	printf("test const\n");

	printf("genericIntConst = %d\n", (int32_t)main_genericIntConst);
	printf("int32Const = %d\n", main_int32Const);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", main_string8Const);

	return 0;
}

