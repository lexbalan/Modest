// examples/stmt_if/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	printf("if statement example\n");

	int32_t a;
	int32_t b;

	printf("enter a: ");
	scanf("%d", &a);
	printf("enter b: ");
	scanf("%d", &b);

	if (a > b) {
		printf("a > b\n");
	} else if (a < b) {
		printf("a < b\n");
	} else {
		printf("a == b\n");
	}

	return 0;
}


