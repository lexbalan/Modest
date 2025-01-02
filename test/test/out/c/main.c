// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



static int32_t a0[5] = (int32_t[5]){0, 1, 2, 3, 4};
static int32_t a1[5] = (int32_t[5]){5, 6, 7, 8, 9};

static int32_t a2[2 * 2 * 5] = (int32_t[2 * 2 * 5]){

	0, 1, 2, 3, 4,
	5, 6, 7, 8, 9,


	10, 11, 12, 13, 14,
	15, 16, 17, 18, 19
};

static int32_t *a3[2] = (int32_t *[2]){&a0[0], &a1[0]};


int32_t main()
{
	//let x = a2[0][1][2]
	//printf("x = %d\n", x)

	int32_t y = a3[0][2];
	printf("y = %d\n", y);

	return 0;
}

