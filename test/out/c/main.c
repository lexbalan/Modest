
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

	int32_t x1 = 5;
	int32_t x2 = 15;

	int32_t a0[10];
	memset(&a0, 0, sizeof a0);
	//
	int32_t a1[5];
	memcpy(&a1, &a0[2], sizeof(int32_t[5]));
	//
	int32_t a2[20];
	memset(&a2, 0, sizeof a2);
	memcpy(&a2[5], &a0, sizeof(int32_t[15 - 5]));
	//
	int32_t a3[20];
	memset(&a3, 0, sizeof a3);
	memcpy(&a3[x1], &a0, sizeof(int32_t[x2 - x1]));
	//
	memcpy(&a3[3], &a2[4], sizeof(int32_t[12 - 3]));

	//	let x = Int8 -1
	//
	//	i32 = Int32 x
	//	u32 = Nat32 x

	// не проверяет дубликаты имен!
	int32_t x = 1;
	//var y: Int32 = 0x1  // error!
	uint32_t z = 1;
	uint32_t w = 0x1;

	const int8_t i8 = (int8_t)-1;
	const uint32_t n32 = ABS(i8);
	const int32_t i32 = (int32_t)i8;
	const uint32_t w32 = (uint32_t)(uint8_t)i8;

	if (((int32_t)(int8_t)-1 == -1) && (i32 == -1)) {
		printf("Int8 -1 -> Int32 (-1) test passed\n");
	} else {
		printf("Int8 -1 -> Int32 test failed\n");
	}

	if ((ABS((int8_t)-1) == 1) && (n32 == 1)) {
		printf("Int8 -1 -> Nat32 (1) test passed\n");
	} else {
		printf("Int8 -1 -> Nat32 test failed\n");
	}

	if (((uint32_t)(uint8_t)(int8_t)-1 == 0xFF) && (w32 == 0xFF)) {
		printf("Int8 -1 -> Word32 (0xff) test passed\n");
	} else {
		printf("Int8 -1 -> Word32 test failed\n");
	}

	//printf("i32 = 0x%08x (%d)\n", i32, i32)
	//printf("u32 = 0x%08x (%d)\n", u32, u32)

	return 0;
}

