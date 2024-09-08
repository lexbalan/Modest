// ./out/c/lib.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "lib.h"




typedef Int XXX;
Int lib_div(Int a, Int b);


Int lib_div(Int a, Int b)
{
	return a / b;
}

Int lib_mid(Int a, Int b)
{
	const Int sum = a + b;
	return lib_div(sum, 2);
}

void lib_printPoint(Point p)
{
	console_printf("p.x = %d\n", p.x);
	console_printf("p.y = %d\n", p.y);
}

