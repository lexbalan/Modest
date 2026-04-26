
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	#define main_x 127
	#define main_y (main_x + 1)
	printf("y = %i\n", (int32_t)main_y);
	if (main_y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
	return 0;
	#undef main_x
	#undef main_y
}

