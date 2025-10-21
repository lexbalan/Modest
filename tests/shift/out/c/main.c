// tests/shift/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



// left must be Word
// right must be Nat

int main() {
	printf("test shift\n");

	uint32_t c;

	c = 0x1 << 31;
	printf("1 << 31 = 0x%x\n", c);

	c = 0x80000000UL >> 31;
	printf("0x80000000 >> 31 = 0x%x\n", c);

	return 0;
}


