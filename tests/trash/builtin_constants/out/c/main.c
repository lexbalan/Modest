
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int main(void) {
	printf("builtin.compiler.name = %s\n", "m2");
	struct {uint32_t major; uint32_t minor; uint32_t patch;} ver = {.major = 0U, .minor = 7U, .patch = 100U};
	printf("builtin.compiler.version.major = %u\n", ver.major);
	printf("builtin.compiler.version.minor = %u\n", ver.minor);
	printf("builtin.target.name = %s\n", "mac");
	printf("builtin.target.pointerWidth = %u\n", 64);
	printf("builtin.target.charWidth = %u\n", 8);
	printf("builtin.target.intWidth = %u\n", 32);
	printf("builtin.target.floatWidth = %u\n", 64);
	return 0;
}

