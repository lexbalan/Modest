// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"




int main()
{
	printf("bool check\nm");

	uint8_t x;
	bool b;

	x = 1;
	b = (bool)x;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	x = 2;
	b = (bool)x;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	x = 3;
	b = (bool)x;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	return 0;
}

