
#ifndef FIXED32_H
#define FIXED32_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

typedef uint32_t fixed32_Fixed32;
fixed32_Fixed32 fixed32_add(fixed32_Fixed32 a, fixed32_Fixed32 b);
fixed32_Fixed32 fixed32_sub(fixed32_Fixed32 a, fixed32_Fixed32 b);
fixed32_Fixed32 fixed32_mul(fixed32_Fixed32 a, fixed32_Fixed32 b);
fixed32_Fixed32 fixed32_div(fixed32_Fixed32 a, fixed32_Fixed32 b);
fixed32_Fixed32 fixed32_fromInt16(int16_t x);
int16_t fixed32_toInt16(fixed32_Fixed32 x);
fixed32_Fixed32 fixed32_create(int16_t a, int16_t b, int16_t c);
void fixed32_print(fixed32_Fixed32 x);

#endif /* FIXED32_H */
