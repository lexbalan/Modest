
#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include "uchar.h"
#else
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#endif
#define __STR_UNICODE__
#define __STR8(x)  x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x)  __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#define _CHR8(x)  (__STR8(x)[0])
#define _CHR16(x) (__STR16(x)[0])
#define _CHR32(x) (__STR32(x)[0])
#endif /* __STR_UNICODE__ */

int main(void);

#endif /* MAIN_H */
