
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	const int8_t x = 127;
	const int8_t y = x + 1;
	printf("y = %i\n", /*$*/((int32_t)y));
	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}
	return 0;
}
