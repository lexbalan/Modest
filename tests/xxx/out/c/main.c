
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef __STR_UNICODE__
#if __has_include(<uchar.h>)
#include <uchar.h>
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




struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

#define HELLO  "Hello"

static char str0[5] = {'H', 'e', 'l', 'l', 'o'};
static char16_t str1[5] = {u'H', u'e', u'l', u'l', u'o'};
static char32_t str2[5] = {U'H', U'e', U'l', U'l', U'o'};

static char *pstr0 = HELLO;
static char16_t *pstr1 = _STR16(HELLO);
static char32_t *pstr2 = _STR32(HELLO);

static void puts8(char *s) {
}


static void puts16(char16_t *s) {
}


static void puts32(char32_t *s) {
}


static void ss(char *_s, char *_sret_) {
	char s[10];
	memcpy(s, _s, sizeof(char[10]));
	char ks[5 - 2];
	memcpy(&ks, (char *)&s[2], sizeof(char[5 - 2]));
	memcpy(_sret_, &s, sizeof(char[10]));
}


int32_t main(void) {
	printf("Hello World!\n");

	char s1[32] = {'H', 'e', 'l', 'l', 'o', '!'};
	char s2[32] = {'W', 'o', 'r', 'l', 'd'};

	puts8(&s1[0]);

	const size_t length = strlen(&s1[0]);
	strcpy(&s2[0], &s1[0]);
	strncpy(&s2[0], &s1[0], 5);

	puts8(&str0[0]);
	puts8(pstr0);

	puts16(&str1[0]);
	puts32(pstr2);

	return 0;
}


// Unit
//public func xxx () -> record {} {
//	return {}
//}

