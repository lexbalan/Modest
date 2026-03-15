
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
typedef int32_t NewInt32;

int main(void) {
	printf("test typedef\n");
	NewInt32 newInt32;
	newInt32 = 0;
	(void)newInt32;
	return 0;
}

