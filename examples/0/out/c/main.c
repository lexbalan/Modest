
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"

static int32_t apart(__fixed32 x);
static int32_t bpart(__fixed32 x);

int main(void) {
	printf("Hello World!\n");
	const __fixed32 fx32 = FIXED32(4.123456, 16);
	printf("fx32 = %d.%d\n", apart(fx32), bpart(fx32));
	return 0;
}

static int32_t apart(__fixed32 x) {
	const uint16_t w16 = (uint16_t)((uint32_t)x >> 16);
	return (int32_t)w16;
}

static int32_t bpart(__fixed32 x) {
	const int64_t i64 = ((uint64_t)((uint32_t)x & 0xFFFF));
	return (int32_t)(i64 * 100000 / 65536);
}

