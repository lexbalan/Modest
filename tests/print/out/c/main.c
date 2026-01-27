
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

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

#include "./console.h"

#include "console.h"



int main(void) {
	console_print("test console print\n");

	const char32_t c = U'🐀';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 0x1234567F;

	console_print("\\\n");// "\\" = "\"
	console_print("@\n");// "\64" = "@"
	console_print("#AA#\n");// "\x23AA\x23" = "#AA#"
	console_print("🎉A\n");// "\u0001F389A" = "🎉A"

	console_print("Это строка записанная кириллицей.\n");

	console_print("{{c}}\n");// {{c}}
	console_print("c = \"{c}\"\n", (const char32_t)c);// c = "🐀"
	console_print("s = \"{s}\"\n", (char*)s);// s = "Hi!"
	console_print("i = {i}\n", i);// i = -1
	console_print("n = {n}\n", n);// n = 123
	console_print("x = 0x{x}\n", x);// x = 0x1234567F

	return 0;
}


