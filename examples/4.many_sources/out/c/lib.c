
#include "lib.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


void lib_foo(void) {
	printf("hello from lib.foo\n");
}


