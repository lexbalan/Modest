
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./console.h"
#include "console.h"
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

int main(void) {
	console_print("test console print\n");
	const char32_t c = U'🐀';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 0x1234567F;
	console_print("\\\n");
	console_print("@\n");
	console_print("#AA#\n");
	console_print("🎉A\n");
	console_print("Это строка записанная кириллицей.\n");
	console_print("{{c}}\n");
	console_print("c = \"{c}\"\n", c);
	console_print("s = \"{s}\"\n", s);
	console_print("i = {i}\n", i);
	console_print("n = {n}\n", n);
	console_print("x = 0x{x}\n", x);
	return 0;
}

