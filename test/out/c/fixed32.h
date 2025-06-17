#ifndef FIXED32_H
#define FIXED32_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

typedef uint32_t fixed32_Fixed32;

// x = a + b / c
fixed32_Fixed32 fixed32_create(int16_t a, uint16_t b, uint16_t c);

void fixed32_print(fixed32_Fixed32 x);

fixed32_Fixed32 fixed32_add(fixed32_Fixed32 a, fixed32_Fixed32 b);

fixed32_Fixed32 fixed32_sub(fixed32_Fixed32 a, fixed32_Fixed32 b);

fixed32_Fixed32 fixed32_mul(fixed32_Fixed32 a, fixed32_Fixed32 b);

fixed32_Fixed32 fixed32_div(fixed32_Fixed32 a, fixed32_Fixed32 b);

fixed32_Fixed32 fixed32_trunc(fixed32_Fixed32 x);

fixed32_Fixed32 fixed32_fract(fixed32_Fixed32 x);

// Округляет вниз (в сторону -∞)
fixed32_Fixed32 fixed32_floor(fixed32_Fixed32 x);

// Округляет вверх (в сторону +∞)
fixed32_Fixed32 fixed32_ceil(fixed32_Fixed32 x);

#endif /* FIXED32_H */
