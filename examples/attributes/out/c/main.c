// examples/1.hello_world/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


__attribute__((section("__DATA, .xdata")))
__attribute__((aligned(8)))
static uint32_t x;

extern int32_t ext;

static inline int32_t staticInlineFunc(int32_t x) {
	return x + 1;
}

int main() {
	printf("Attributes example\n");
	return 0;
}

