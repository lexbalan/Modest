
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "fixed64.h"


// FIXIT! (Word64 Int64 1)
#define multiplier  ((int64_t)(((uint64_t)1) << 32))

fixed64_Fixed64 fixed64_add(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	return (fixed64_Fixed64)((int64_t)a + (int64_t)b);
}

fixed64_Fixed64 fixed64_sub(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	return (fixed64_Fixed64)((int64_t)a - (int64_t)b);
}

fixed64_Fixed64 fixed64_mul(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	const __int128 a128 = (__int128)a;
	const __int128 b128 = (__int128)b;
	return (fixed64_Fixed64)(a128 * b128 / (__int128)multiplier);
}

fixed64_Fixed64 fixed64_div(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	const __int128 wa = (__int128)a;
	const __int128 wb = (__int128)b;
	return (fixed64_Fixed64)(wa * (__int128)multiplier / wb);
}

fixed64_Fixed64 fixed64_fromInt32(int32_t x) {
	return (fixed64_Fixed64)((int64_t)x * multiplier);
}

int32_t fixed64_toInt32(fixed64_Fixed64 x) {
	return (int32_t)((int64_t)x / multiplier);
}

fixed64_Fixed64 fixed64_head(fixed64_Fixed64 x) {
	return fixed64_fromInt32(fixed64_toInt32(x));
}

fixed64_Fixed64 fixed64_tail(fixed64_Fixed64 x) {
	return fixed64_sub(x, fixed64_head(x));
}

fixed64_Fixed64 fixed64_create(int32_t a, int32_t b, int32_t c) {
	const fixed64_Fixed64 tail = fixed64_div(fixed64_fromInt32(b), fixed64_fromInt32(c));
	const fixed64_Fixed64 head = fixed64_fromInt32(a);
	return fixed64_add(head, tail);
}

void fixed64_print(fixed64_Fixed64 x) {
	const int64_t a = (int64_t)x / multiplier;
	int64_t b = (int64_t)x % multiplier;
	int64_t c = multiplier;

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

	printf("%lld+%lld/%lld", a, b, c);

	const int32_t d = fixed64_toInt32(x);
	const int64_t e = (int64_t)fixed64_tail(x) * 1000000 / multiplier;
	printf(" = %d.%lld\n", d, e);
}

