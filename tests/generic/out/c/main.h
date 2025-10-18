// tests/1.hello_world/src/main.m

#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

#ifndef __STR_UNICODE__
#define __STR_UNICODE__
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif /* __STR_UNICODE__ */
int main();

#endif /* MAIN_H */
