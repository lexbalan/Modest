
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"






static int32_t main_v0;

//@attribute("value:nodecorate")
void main_f0()
{
}

static int32_t i32;
static uint32_t u32;

int32_t main()
{
	main_Point p;
	printf("test %s\n", (char *)main_cq);
	printf("test %d\n", main_v0);
	main_f0();

	const int8_t x = (int8_t)-1;

	i32 = (int32_t)x;
	u32 = ((uint32_t)(uint8_t)x);
	printf("i32 = 0x%08x (%d)\n", i32, i32);
	printf("u32 = 0x%08x (%d)\n", u32, u32);
	return 0;
}

