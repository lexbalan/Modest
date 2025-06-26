
#ifndef FIXED64_H
#define FIXED64_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

typedef uint64_t fixed64_Fixed64;
fixed64_Fixed64 fixed64_add(fixed64_Fixed64 a, fixed64_Fixed64 b);
fixed64_Fixed64 fixed64_sub(fixed64_Fixed64 a, fixed64_Fixed64 b);
fixed64_Fixed64 fixed64_mul(fixed64_Fixed64 a, fixed64_Fixed64 b);
fixed64_Fixed64 fixed64_div(fixed64_Fixed64 a, fixed64_Fixed64 b);
fixed64_Fixed64 fixed64_fromInt32(int32_t x);
int32_t fixed64_toInt32(fixed64_Fixed64 x);
fixed64_Fixed64 fixed64_head(fixed64_Fixed64 x);
fixed64_Fixed64 fixed64_tail(fixed64_Fixed64 x);
fixed64_Fixed64 fixed64_create(int32_t a, int32_t b, int32_t c);
void fixed64_print(fixed64_Fixed64 x);

#endif /* FIXED64_H */
