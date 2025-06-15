#ifndef FIXED_H
#define FIXED_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

typedef uint32_t fixed_Fixed32;
fixed_Fixed32 fixed_create(int16_t a, uint16_t b, uint16_t c);

void fixed_print(fixed_Fixed32 x);

fixed_Fixed32 fixed_add(fixed_Fixed32 a, fixed_Fixed32 b);

fixed_Fixed32 fixed_sub(fixed_Fixed32 a, fixed_Fixed32 b);

fixed_Fixed32 fixed_mul(fixed_Fixed32 a, fixed_Fixed32 b);

fixed_Fixed32 fixed_div(fixed_Fixed32 a, fixed_Fixed32 b);

#endif /* FIXED_H */
