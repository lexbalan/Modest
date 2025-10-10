// examples/prefix/src/lib.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "lib.h"


//pragma append_prefix loo

int32_t loo_spam = 4;

void loo_foo(uint32_t x) {
	printf("foo(%d)\n", x);
}


