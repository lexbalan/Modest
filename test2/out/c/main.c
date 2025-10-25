// test2

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



// Закладывай доставку в цену ramburs

#define C0  40

static int32_t a0[4] = {10, 20, 30, C0};
static int32_t a1[4] = {10, 20, 30, C0};

struct Point
{
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

static Point points[2] = {{.x = 0, .y = 0}, {.x = 1, .y = 1}};

int32_t main()
{
	printf("test2\n");

	int32_t v0 = 10;
	int32_t la0[5];
	memcpy(&la0, &(int32_t[5]){10, 20, 30, C0, v0}, sizeof(int32_t[5]));
	int32_t la1[5];
	memcpy(&la1, &(int32_t[5]){10, 20, 30, C0, v0}, sizeof(int32_t[5]));

	return 0;
}


#undef C0

