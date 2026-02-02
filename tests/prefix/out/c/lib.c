
#include "lib.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


int32_t loo_spam = 4;

void loo_foo(uint32_t x) {
	printf("foo(%d)\n", x);
}


