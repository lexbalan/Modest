// examples/stmt_while/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	printf("while statement test\n");

	uint32_t a = 0;
	const uint32_t b = 10;

	while (a < b) {
		printf("a = %d\n", a);
		a = a + 1;
	}

	return 0;
}


