
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("while statement test\n");
	uint32_t a = 0U;
	const uint32_t b = 10U;
	while (a < b) {
		printf("a = %d\n", a);
		a = a + 1U;
	}
	return 0;
}

