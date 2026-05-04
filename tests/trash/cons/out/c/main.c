
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("test cons operation\n");
	const uint8_t a = 0xFF;
	const uint32_t b = (uint32_t)a;
	printf("a = %u\n", a);
	printf("b = %u\n", b);
	return 0;
}

