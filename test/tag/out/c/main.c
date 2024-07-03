// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




static uint32_t x;

//@undef("x")
//var x: Int32


int main()
{
	printf("tag test");

	int32_t dst2[5];
	memcpy(&/*var*/dst2, &/*cons*/(int32_t[5]){10, 20, 30, 40, 50}, sizeof(int32_t[5]));

	uint8_t axx;
	axx = 11;
	uint8_t bxx;
	bxx = 12;

	// not worked with var!
	#define i2  3
	#define j2  5
	memcpy(&/*slice*/dst2[i2], &/*literal*/(int32_t[j2 - i2]){(int32_t)axx, (int32_t)bxx}, sizeof(int32_t[j2 - i2]));

	return 0;
}

#undef i2
#undef j2

