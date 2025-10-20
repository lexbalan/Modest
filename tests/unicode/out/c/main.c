// unicode support test

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"


#define a  "A"

static char c8 = 'A';
static char16_t c16 = _CHR16(a);
static char32_t c32 = _CHR32(a);

static char b8[1] = a;
static char16_t b16[1] = _STR16(a);
static char32_t b32[1] = _STR32(a);

static char *s8 = a;
static char16_t *s16 = _STR16(a);
static char32_t *s32 = _STR32(a);

static char cc8 = 'A';
static char16_t cc16 = _CHR16("A");
static char32_t cc32 = _CHR32("A");

static char bb8[1] = "A";
static char16_t bb16[1] = _STR16("A");
static char32_t bb32[1] = _STR32("A");

static char *ss8 = "A";
static char16_t *ss16 = _STR16("A");
static char32_t *ss32 = _STR32("A");


static void putc8(char c);
static void putc16(char16_t c);
static void putc32(char32_t c);
static void puts8(char *s);
static void puts16(char16_t *s);
static void puts32(char32_t *s);

int32_t main()
{
	printf("test unicode\n");

	putc8('A');
	putc16(_CHR16(a));
	putc32(_CHR32(a));

	puts8(a);
	puts16(_STR16(a));
	puts32(_STR32(a));

	putc8('A');
	putc16(_CHR16("A"));
	putc32(_CHR32("A"));

	puts8("A");
	puts16(_STR16("A"));
	puts32(_STR32("A"));

	return 0;
}


static void putc8(char c)
{
}

static void putc16(char16_t c)
{
}

static void putc32(char32_t c)
{
}


static void puts8(char *s)
{
}

static void puts16(char16_t *s)
{
}

static void puts32(char32_t *s)
{
}


