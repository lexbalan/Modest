// tests/let/src/main.m

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


int main()
{
	const uint8_t x = 127;
	const uint8_t y = x + 1;

	printf("y = %i\n", (int32_t)y);

	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

