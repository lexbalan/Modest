
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"


extern void xxx();

struct Point
{
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

static Point points[3] = {
	{.x = 0, .y = 0},
	{.x = 1, .y = 1},
	{.x = 2, .y = 2}
};

int32_t main()
{
	printf("test2\n");
	return 0;
}


