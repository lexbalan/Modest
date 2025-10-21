// tests/bool/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main() {
	printf("bool check\nm");

	uint8_t x;
	bool b;

	x = 1;
	//b = Bool x
	b = x != 0;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	x = 2;
	//b = Bool x
	b = x != 0;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	x = 3;
	//b = Bool x
	b = x != 0;
	printf("x = %u\n", (uint32_t)x);
	printf("x to Bool = %u\n", (uint32_t)b);

	return 0;
}


