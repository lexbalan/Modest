// examples/1.hello_world/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


__attribute__((section("__DATA, .xdata")))
__attribute__((aligned(2)))
static int32_t x;

int main() {
	printf("Attributes example\n");
	return 0;
}

