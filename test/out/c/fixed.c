
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "fixed.h"


#define base  65536
fixed_Fixed32 fixed_create(int16_t a, uint16_t b, uint16_t c)
{
	const uint32_t ntail = (uint32_t)b * base / (uint32_t)c;
	return ((uint32_t)((int32_t)a * base) | ntail);
}

static int16_t head(fixed_Fixed32 x)
{
	return (int16_t)(x >> 16);
}

static uint16_t tail(fixed_Fixed32 x)
{
	return (uint16_t)((x) & (base - 1));
}

void fixed_print(fixed_Fixed32 x)
{
	const int16_t a = head(x);
	uint32_t b = (uint32_t)tail(x);
	uint32_t c = base;

	// сокращаем дробную часть
	while (true)
	{
		if ((b % 2 == 0) && (c % 2 == 0))
		{
			b = b / 2;
			c = c / 2;
		}
		else if ((b % 3 == 0) && (c % 3 == 0))
		{
			b = b / 3;
			c = c / 3;
		}
		else
		{
			break;
		}
	}

	printf("%d+%d/%d\n", a, b, c);
}

fixed_Fixed32 fixed_add(fixed_Fixed32 a, fixed_Fixed32 b)
{
	return (fixed_Fixed32)((int32_t)a + (int32_t)b);
}

fixed_Fixed32 fixed_sub(fixed_Fixed32 a, fixed_Fixed32 b)
{
	return (fixed_Fixed32)((int32_t)a - (int32_t)b);
}

fixed_Fixed32 fixed_mul(fixed_Fixed32 a, fixed_Fixed32 b)
{
	const int64_t ax = (int64_t)a;
	const int64_t bx = (int64_t)b;
	const int64_t cx = ax * bx / base;
	return (fixed_Fixed32)cx;
}

fixed_Fixed32 fixed_div(fixed_Fixed32 a, fixed_Fixed32 b)
{
	const int64_t ax = (int64_t)a;
	const int64_t bx = (int64_t)b;
	const int64_t cx = ax * base / bx;
	return (fixed_Fixed32)cx;
}

