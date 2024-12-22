// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



int main()
{
	#define __x  127U
	#define __y  (__x + 1)

	printf("y = %i\n", (int32_t)__y);

	if (__y == 128U) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;

#undef __x
#undef __y
}

