
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("builtin.compiler.name = %s\n", "m2");
	#define ver {.major = 0U, .minor = 7U}
	printf("builtin.compiler.version.major = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).major);
	printf("builtin.compiler.version.minor = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).minor);
	printf("builtin.compiler.version.major = %u\n", 0U);
	printf("builtin.compiler.version.minor = %u\n", 7U);
	printf("builtin.target.name = %s\n", "Default");
	printf("builtin.target.pointerWidth = %u\n", 64);
	printf("builtin.target.charWidth = %u\n", 8);
	printf("builtin.target.intWidth = %u\n", 32);
	printf("builtin.target.floatWidth = %u\n", 64);
	return 0;
	#undef ver
}

