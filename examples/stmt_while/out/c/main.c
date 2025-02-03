
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <stdio.h>


int main()
{
	printf("while statement test\n");

	int32_t a = 0;
	#define __b  10

	while (a < __b) {
		printf("a = %d\n", a);
		a = a + 1;
	}

	return 0;

#undef __b
}

