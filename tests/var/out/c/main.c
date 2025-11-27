
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define ARR  {1, 2}

static int32_t arr0[2] = ARR;
static int32_t arr1[2] = ARR;
static char *str = "Hello!";// -> *[]Char8

int main(void) {
	int32_t x = 127;
	int32_t y = x + 1;

	printf("y = %i\n", y);

	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}


