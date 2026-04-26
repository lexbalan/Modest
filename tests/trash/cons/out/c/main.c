
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("test cons operation\n");
	const uint8_t main_a = 255;
	const uint32_t main_b = (uint32_t)main_a;
	printf("a = %u\n", main_a);
	printf("b = %u\n", main_b);
	return 0;
}

