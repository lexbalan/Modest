// unicode support test

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"

#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)

#define a  "A"

static char c8 = a[0];
static uint16_t c16 = _STR16(a)[0];
static uint32_t c32 = _STR32(a)[0];

static char b8[1] = a;
static uint16_t b16[1] = _STR16(a);
static uint32_t b32[1] = _STR32(a);

static char *s8 = a;
static uint16_t *s16 = _STR16(a);
static uint32_t *s32 = _STR32(a);


static void putc8(char c);
static void putc16(uint16_t c);
static void putc32(uint32_t c);

int32_t main()
{
	printf("test2\n");
	putc8("A"[0]);
	putc16(_STR16("A")[0]);
	putc32(_STR32("A")[0]);
	return 0;
}


static void putc8(char c)
{
}

static void putc16(uint16_t c)
{
}

static void putc32(uint32_t c)
{
}


