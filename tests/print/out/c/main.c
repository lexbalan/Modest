// tests/print/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"


int main() {
	console_print("test console print\n");

	const uint32_t c = U'🐀';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 305419903;

	console_print("\\\n");
	console_print("@\n");
	console_print("#AA#\n");
	console_print(U"🎉A\n");

	console_print(u"Это строка записанная кириллицей.\n");

	console_print("{{c}}\n");
	console_print("c = \"{c}\"\n", c);
	console_print("s = \"{s}\"\n", s);
	console_print("i = {i}\n", i);
	console_print("n = {n}\n", n);
	console_print("x = 0x{x}\n", x);

	return 0;
}

