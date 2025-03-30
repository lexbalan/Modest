// examples/stmt_while/src/main.m

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


int main()
{
	printf("while statement test\n");

	int32_t a = 0;
	const uint8_t b = 10;

	while (a < (int32_t)b) {
		printf("a = %d\n", a);
		a = a + 1;
	}

	return 0;
}

