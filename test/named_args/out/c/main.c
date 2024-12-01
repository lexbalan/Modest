// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





static int32_t named_args_test(int32_t a, int32_t b, int32_t c)
{
	return (a - b) * c;
}

int main()
{
	printf("test named_args\n");

	#define __a  25
	#define __b  15
	#define __c  3

	#define __x0  ((__a - __b) * __c)

	const int32_t x1 = named_args_test(__a, __b, __c);

	if (__x0 == x1) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;

#undef __a
#undef __b
#undef __c
#undef __x0
}

