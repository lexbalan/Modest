// tests/builtin_constants/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {

	// __compiler
	printf("__compiler.name = %s\n", "m2");
	#define ver  {.major = 0, .minor = 7}
	printf("__compiler.version.major = %u\n", ((struct {uint32_t major; uint32_t minor;
	})ver).major);
	printf("__compiler.version.minor = %u\n", ((struct {uint32_t major; uint32_t minor;
	})ver).minor);

	// __target
	printf("__target.name = %s\n", "Default");
	printf("__target.pointerWidth = %u\n", 64);
	printf("__target.charWidth = %u\n", 8);
	printf("__target.intWidth = %u\n", 32);
	printf("__target.floatWidth = %u\n", 64);

	return 0;

#undef ver
}


