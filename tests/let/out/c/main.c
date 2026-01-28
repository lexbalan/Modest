
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {
	#define x  127
	#define y  (x + 1)

	printf(/*4*/"y = %i\n", (int32_t)y);

	if (y == 128) {
		printf(/*4*/"test passed\n");
	} else {
		printf(/*4*/"test failed\n");
	}

	return 0;

#undef x
#undef y
}


