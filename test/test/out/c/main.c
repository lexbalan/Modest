// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



static void f0()
{
	return;
}

static void(*a3[5])() = (void(*[5])()){&f0};

int32_t main()
{

	return 0;
}

