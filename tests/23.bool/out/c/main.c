
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	printf(/*4*/"bool check\nm");

	uint8_t x;
	bool b;

	x = 1;
	//b = Bool x
	b = x != 0;
	printf(/*4*/"x = %u\n", (uint32_t)x);
	printf(/*4*/"x to Bool = %u\n", (uint32_t)b);

	x = 2;
	//b = Bool x
	b = x != 0;
	printf(/*4*/"x = %u\n", (uint32_t)x);
	printf(/*4*/"x to Bool = %u\n", (uint32_t)b);

	x = 3;
	//b = Bool x
	b = x != 0;
	printf(/*4*/"x = %u\n", (uint32_t)x);
	printf(/*4*/"x to Bool = %u\n", (uint32_t)b);

	return 0;
}


