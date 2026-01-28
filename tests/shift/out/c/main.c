
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



// left must be Word
// right must be Nat

int main(void) {
	printf(/*4*/"test shift\n");

	uint32_t c;

	c = 0x1 << 31;
	printf(/*4*/"1 << 31 = 0x%x\n", c);

	c = 0x80000000UL >> 31;
	printf(/*4*/"0x80000000 >> 31 = 0x%x\n", c);

	return 0;
}


