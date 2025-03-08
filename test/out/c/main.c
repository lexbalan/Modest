
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#define ABS(x) ((x) < 0 ? -(x) : (x))





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

	//	let x = Int8 -1
	//
	//	i32 = Int32 x
	//	u32 = Nat32 x

	if ((int32_t)(int8_t)-1 == (int32_t)-1) {
		printf("Int8 -1 -> Int32 test passed\n");
	} else {
		printf("Int8 -1 -> Int32 test failed\n");
	}

	if (ABS((int8_t)-1) == 1) {
		printf("Int8 -1 -> Nat32 test passed\n");
	} else {
		printf("Int8 -1 -> Nat32 test failed\n");
	}

	const uint32_t c3 = ((uint32_t)(uint8_t)(int8_t)-1);
	if (c3 == 0xFF) {
		printf("Int8 -1 -> Word32 test passed\n");
	} else {
		printf("Int8 -1 -> Word32 test failed\n");
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0;
}

