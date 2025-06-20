
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "fixed64.h"


#define multiplier  ((int64_t)(((uint64_t)1) << 32))

fixed64_Fixed64 fixed64_add(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	return a + b;
}

fixed64_Fixed64 fixed64_sub(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	return a - b;
}

fixed64_Fixed64 fixed64_mul(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	const __int128 a128 = (__int128)a;
	const __int128 b128 = (__int128)b;
	const __int128 v128 = a128 * b128 / (__int128)multiplier;
	return (fixed64_Fixed64)v128;
}

fixed64_Fixed64 fixed64_div(fixed64_Fixed64 a, fixed64_Fixed64 b) {
	const __int128 wa = (__int128)a;
	const __int128 wb = (__int128)b;
	const __int128 v64 = (wa * (__int128)multiplier) / wb;
	return (fixed64_Fixed64)v64;
}

fixed64_Fixed64 fixed64_fromInt32(int32_t x) {
	return (fixed64_Fixed64)x * (fixed64_Fixed64)multiplier;
}

int32_t fixed64_toInt32(fixed64_Fixed64 x) {
	return (int32_t)(x / (fixed64_Fixed64)multiplier);
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

	printf("%lld+%lld/%lld\n", a, b, c);
}

