// tests/named_args/src/main.m

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


static int32_t named_args_test(int32_t a, int32_t b, int32_t c)
{
	return (a - b) * c;
}

int main()
{
	printf("test named_args\n");

	const uint8_t a = 25;
	const uint8_t b = 15;
	const uint8_t c = 3;

	const uint8_t x0 = (a - b) * c;

	const int32_t x1 = named_args_test(
		/*a=*/(int32_t)a,
		/*b=*/(int32_t)b,
		/*c=*/(int32_t)c
	);

	if ((int32_t)x0 == x1) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

