
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


int main(void) {
	#define x  127
	#define y  (x + 1)

	printf("y = %i\n", (int32_t)y);

	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;

#undef x
#undef y
}


