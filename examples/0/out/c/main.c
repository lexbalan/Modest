
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#if !defined(__STR_UNICODE__)
#define __STR_UNICODE__
typedef uint8_t char8_t;
typedef uint16_t char16_t;
typedef uint32_t char32_t;
#define __STR8(x) x
#define __STR16(x) u##x
#define __STR32(x) U##x
#define _STR8(x) __STR8(x)
#define _STR16(x) __STR16(x)
#define _STR32(x) __STR32(x)
#endif
#define RAT_SYMBOL U"🐀"
static char a[10];

static char *foo(void) {
	return NULL;
}

int main(void) {
	printf("Hello World!\n");
	int i = 10;
	char *slice = &a[0];
	slice = foo();
	char32_t c32 = RAT_SYMBOL[0];
	printf("c32 = {0x%x}\n", c32);
	char a = "é"[0];
	printf("a = {0x%x}\n", a);
	return 0;
}

