
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "fixed32.h"


#define multiplier  ((int32_t)(0x1 << 16))

fixed32_Fixed32 fixed32_add(fixed32_Fixed32 a, fixed32_Fixed32 b) {
	return (fixed32_Fixed32)((int32_t)a + (int32_t)b);
}

fixed32_Fixed32 fixed32_sub(fixed32_Fixed32 a, fixed32_Fixed32 b) {
	return (fixed32_Fixed32)((int32_t)a - (int32_t)b);
}

fixed32_Fixed32 fixed32_mul(fixed32_Fixed32 a, fixed32_Fixed32 b) {
	const int64_t a64 = (int64_t)a;
	const int64_t b64 = (int64_t)b;
	return (fixed32_Fixed32)(a64 * b64 / (int64_t)multiplier);
}

fixed32_Fixed32 fixed32_div(fixed32_Fixed32 a, fixed32_Fixed32 b) {
	const int64_t a64 = (int64_t)a;
	const int64_t b64 = (int64_t)b;
	return (fixed32_Fixed32)(a64 * (int64_t)multiplier / b64);
}

fixed32_Fixed32 fixed32_fromInt16(int16_t x) {
	return (fixed32_Fixed32)((int32_t)x * multiplier);
}

int16_t fixed32_toInt16(fixed32_Fixed32 x) {
	return (int16_t)((int32_t)x / multiplier);
}

fixed32_Fixed32 fixed32_create(int16_t a, int16_t b, int16_t c) {
	const fixed32_Fixed32 tail = fixed32_div(fixed32_fromInt16(b), fixed32_fromInt16(c));
	const fixed32_Fixed32 head = fixed32_fromInt16(a);
	return fixed32_add(head, tail);
}

void fixed32_print(fixed32_Fixed32 x) {
	const int32_t a = (int32_t)x / multiplier;
	int32_t b = (int32_t)x % multiplier;
	int32_t c = multiplier;

	// сокращаем дробную часть
	while (true) {
		if ((b % 2 == 0) && (c % 2 == 0)) {
			b = b / 2;
			c = c / 2;
		} else if ((b % 3 == 0) && (c % 3 == 0)) {
			b = b / 3;
			c = c / 3;
		} else {
			break;
		}
	}

	printf("%d+%d/%d\n", a, b, c);
}

