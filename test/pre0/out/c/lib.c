// ./out/c/lib.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "lib.h"




typedef Int XXX;
Int div(Int a, Int b);


Int div(Int a, Int b)
{
	return a / b;
}

Int mid(Int a, Int b)
{
	const Int sum = a + b;
	return div(sum, 2);
}

void printPoint(Point p)
{
	printf("p.x = %d\n", p.x);
	printf("p.y = %d\n", p.y);
}

