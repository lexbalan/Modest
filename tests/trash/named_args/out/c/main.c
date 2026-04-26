
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static int32_t main_named_args_test(int32_t a, int32_t b, int32_t c) {
	return (a - b) * c;
}

int main(void) {
	printf("test named_args\n");
	#define main_a 25
	#define main_b 15
	#define main_c 3
	#define main_x0 ((main_a - main_b) * main_c)
	const int32_t main_x1 = main_named_args_test(main_a, main_b, main_c);
	if (main_x0 == main_x1) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
	return 0;
	#undef main_a
	#undef main_b
	#undef main_c
	#undef main_x0
}

