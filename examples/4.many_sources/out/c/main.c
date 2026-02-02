
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "lib.h"

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


int main(void) {
	printf("hello from main\n");
	lib_foo();
	return 0;
}


