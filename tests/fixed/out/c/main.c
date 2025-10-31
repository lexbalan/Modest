// tests/fixed/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


int main() {
	//printf("%s-endian\n", kind)
	const fixed64_Fixed64 a = fixed64_fromInt32(-10);
	const fixed64_Fixed64 b = fixed64_fromInt32(3);
	const fixed64_Fixed64 pi = fixed64_create(3, 141592, 1000000);

	const int32_t u = 5;

	uint64_t y = 8589934591UL;
	int64_t z = 8589934591L;

	printf("pi (%llx):\n", pi);
	fixed64_print(pi);

	printf("div:\n");
	const fixed64_Fixed64 c = fixed64_div(a, b);
	fixed64_print(c);

	printf("mul:\n");
	const fixed64_Fixed64 d = fixed64_mul(a, b);
	fixed64_print(d);

	printf("add:\n");
	const fixed64_Fixed64 e = fixed64_add(a, b);
	fixed64_print(e);

	printf("sub:\n");
	const fixed64_Fixed64 f = fixed64_sub(a, b);
	fixed64_print(f);

	int32_t i = fixed64_toInt32(c);
	printf("i = %d\n", i);

	const fixed64_Fixed64 x = fixed64_create(1, 3, 2);
	fixed64_print(x);

	return 0;
}

