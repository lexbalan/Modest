
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	printf(/*4*/"if statement example\n");

	int32_t a;
	int32_t b;

	printf(/*4*/"enter a: ");
	scanf(/*4*/"%d", (int32_t *)&a);
	printf(/*4*/"enter b: ");
	scanf(/*4*/"%d", (int32_t *)&b);

	if (a > b) {
		printf(/*4*/"a > b\n");
	} else if (a < b) {
		printf(/*4*/"a < b\n");
	} else {
		printf(/*4*/"a == b\n");
	}

	return 0;
}


