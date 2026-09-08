
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"

static int32_t apart(__fixed32 x);
static int32_t bpart(__fixed32 x, uint32_t precision);

int main(void) {
	printf("Hello World!\n");
	const __fixed32 fx32 = FIXED32(4.123456, 16);
	printf("fx32 = %d.%d\n", apart(fx32), bpart(fx32, 100000000));
	const __fixed32 fx322 = __FIXED32_DIV(fx32, FIXED32(2, 16), 16);
	printf("fx322 = %d.%d\n", apart(fx322), bpart(fx322, 100000000));
	return 0;
}

static int32_t apart(__fixed32 x) {
	const uint16_t w16 = (uint16_t)((uint32_t)x >> 16);
	return (int32_t)w16;
}

static int32_t bpart(__fixed32 x, uint32_t precision) {
	const int64_t i64 = ((uint64_t)((uint32_t)x & 0xFFFF));
	return (int32_t)(i64 * (int64_t)precision / 65536);
}

