// test2

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



#define C0  40

static int32_t a0[4] = {10, 20, 30, C0};
static int32_t a1[4] = {10, 20, 30, C0};

int32_t main()
{
	printf("test2\n");

	int32_t v0 = 10;
	int32_t la0[5] = {10, 20, 30, C0};
	int32_t la1[5] = {10, 20, 30, C0};

	return 0;
}


#undef C0

