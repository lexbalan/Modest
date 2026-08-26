
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
static int32_t a = 10;
static int32_t b = 6;
static int32_t c = 4;

int main(void) {
	printf("Hello World!\n");
	const int32_t x = a - (b - c);
	printf("a - (b - c) = %d\n", x);
	return 0;
}

