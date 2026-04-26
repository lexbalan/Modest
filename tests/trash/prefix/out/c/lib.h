
#if !defined(LOO_H)
#define LOO_H
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
struct lib_nothing {uint8_t __placeholder;};
#define LIB_BAR 4
extern int32_t lib_spam;
void lib_foo(uint32_t x);
#endif

