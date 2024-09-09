// ./out/c/lib.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "lib.h"




typedef lib_Int lib_XXX;
lib_Int lib_div(lib_Int a, lib_Int b);


lib_Int lib_div(lib_Int a, lib_Int b)
{
	return a / b;
}

lib_Int lib_mid(lib_Int a, lib_Int b)
{
	const lib_Int sum = a + b;
	return lib_div(sum, 2);
}

void lib_printPoint(lib_Point p)
{
	printf("p.x = %d\n", p.x);
	printf("p.y = %d\n", p.y);
}

