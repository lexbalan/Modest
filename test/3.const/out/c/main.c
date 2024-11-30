// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define genericIntConst  42
#define int32Const  ((int32_t)genericIntConst)
#define genericStringConst  "Hello!"
#define string8Const  (char *)genericStringConst
#define string16Const  u"Hello!"
#define string32Const  U"Hello!"


struct Point {
	uint32_t x;
	uint32_t y;
};
#define _ps  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}
const struct {int8_t x; int8_t y;} ps[3] = _ps;
#define _points  _ps
const Point points[3] = _points;



static Point points2[3] = _points;

int main()
{
	printf("test const\n");

	printf("genericIntConst = %d\n", (int32_t)genericIntConst);
	printf("int32Const = %d\n", int32Const);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const);

	return 0;
}

