// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



int main()
{

	// __compiler
	printf("__compiler.name = %s\n", (char *)"m2");
	#define __ver  {.major = 0, .minor = 7}
	printf("__compiler.version.major = %u\n", 0);
	printf("__compiler.version.minor = %u\n", 7);

	// __target
	printf("__target.name = %s\n", (char *)"Default");
	printf("__target.pointerWidth = %u\n", 64);
	printf("__target.charWidth = %u\n", 8);
	printf("__target.intWidth = %u\n", 32);
	printf("__target.floatWidth = %u\n", 64);

	return 0;

#undef __ver
}

