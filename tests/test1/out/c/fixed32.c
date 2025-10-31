
#include "fixed32.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>


#define base  65536

// x = a + b / c
fixed32_Fixed32 fixed32_create(int16_t a, uint16_t b, uint16_t c)
{
	const uint32_t ntail = (uint32_t)b * base / (uint32_t)c;
	return (fixed32_Fixed32)((uint32_t)((int32_t)a * base) | ntail);
}


static int16_t head(fixed32_Fixed32 x)
{
	return (int16_t)(x >> 16);
}


static uint16_t tail(fixed32_Fixed32 x)
{
	return (uint16_t)(((uint32_t)x) & (base - 1));
}


fixed32_Fixed32 fixed32_fromInt16(int16_t x)
{
	return fixed32_create(x, 0, 1);
}


int16_t fixed32_toInt16(fixed32_Fixed32 x)
{
	return head(x);
}


void fixed32_print(fixed32_Fixed32 x)
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

	printf("%d+%d/%d\n", (int32_t)a, b, c);
}


fixed32_Fixed32 fixed32_add(fixed32_Fixed32 a, fixed32_Fixed32 b)
{
	return (fixed32_Fixed32)((int32_t)a + (int32_t)b);
}


fixed32_Fixed32 fixed32_sub(fixed32_Fixed32 a, fixed32_Fixed32 b)
{
	return (fixed32_Fixed32)((int32_t)a - (int32_t)b);
}


fixed32_Fixed32 fixed32_mul(fixed32_Fixed32 a, fixed32_Fixed32 b)
{
	const int64_t ax = (int64_t)a;
	const int64_t bx = (int64_t)b;
	const int64_t cx = ax * bx / base;
	return (fixed32_Fixed32)cx;
}


fixed32_Fixed32 fixed32_div(fixed32_Fixed32 a, fixed32_Fixed32 b)
{
	const int64_t ax = (int64_t)a;
	const int64_t bx = (int64_t)b;
	const int64_t cx = ax * base / bx;
	return (fixed32_Fixed32)cx;
}


fixed32_Fixed32 fixed32_trunc(fixed32_Fixed32 x)
{
	return (fixed32_Fixed32)((uint32_t)x & 0xFFFF0000UL);
}


fixed32_Fixed32 fixed32_fract(fixed32_Fixed32 x)
{
	return (fixed32_Fixed32)((uint32_t)x & 0xFFFF);
}


// Округляет вниз (в сторону -∞)
fixed32_Fixed32 fixed32_floor(fixed32_Fixed32 x)
{
	int16_t y = head(x);
	return fixed32_create(y, 0, 1);
}


// Округляет вверх (в сторону +∞)
fixed32_Fixed32 fixed32_ceil(fixed32_Fixed32 x)
{
	int16_t y = head(x);
	if (tail(x) > 0)
	{
		y = y + 1;
	}
	return fixed32_create(y, 0, 1);
}


