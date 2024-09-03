// ./out/c/sub.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "sub.h"




typedef int64_t MyInt;// local decls

int32_t add(int32_t a, int32_t b);
int32_t sub(int32_t a, int32_t b);
int32_t mid(int32_t a, int32_t b);// defs


int32_t add(int32_t a, int32_t b)
{
	return a + b;
}

int32_t sub(int32_t a, int32_t b)
{
	return a - b;
}


