
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int main(void) {

	// __compiler
	printf(/*4*/"__compiler.name = %s\n", /*4*/(char*)"m2");
	#define ver  {.major = 0, .minor = 7}
	printf(/*4*/"__compiler.version.major = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).major);
	printf(/*4*/"__compiler.version.minor = %u\n", ((struct {uint32_t major; uint32_t minor;})ver).minor);

	printf(/*4*/"__compiler.version.major = %u\n", 0);
	printf(/*4*/"__compiler.version.minor = %u\n", 7);

	// __target
	printf(/*4*/"__target.name = %s\n", /*4*/(char*)"Default");
	printf(/*4*/"__target.pointerWidth = %u\n", 64);
	printf(/*4*/"__target.charWidth = %u\n", 8);
	printf(/*4*/"__target.intWidth = %u\n", 32);
	printf(/*4*/"__target.floatWidth = %u\n", 64);

	return 0;

#undef ver
}


