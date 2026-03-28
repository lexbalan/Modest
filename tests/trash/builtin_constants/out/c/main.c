
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("__compiler.name = %s\n", "m2");
	#define ver {.major = 0U, .minor = 7U}
	printf("__compiler.version.major = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).major);
	printf("__compiler.version.minor = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).minor);
	printf("__compiler.version.major = %u\n", 0U);
	printf("__compiler.version.minor = %u\n", 7U);
	printf("__target.name = %s\n", "Default");
	printf("__target.pointerWidth = %u\n", 64U);
	printf("__target.charWidth = %u\n", 8U);
	printf("__target.intWidth = %u\n", 32U);
	printf("__target.floatWidth = %u\n", 64U);
	return 0;
	#undef ver
}

