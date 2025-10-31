// examples/prefix/src/lib.m

#ifndef LOO_H
#define LOO_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>


struct loo_Nothing {
};
typedef struct loo_Nothing loo_Nothing;

#define LOO_BAR  4

extern int32_t loo_spam;
void loo_foo(uint32_t x);

#endif /* LOO_H */
