
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static int32_t named_args_test(int32_t a, int32_t b, int32_t c) {
	return (a - b) * c;
}


int main(void) {
	printf("test named_args\n");

	#define a  25
	#define b  15
	#define c  3

	#define x0  ((a - b) * c)

	const int32_t x1 = named_args_test(a, b, c);

	if (x0 == x1) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;

#undef a
#undef b
#undef c
#undef x0
}


