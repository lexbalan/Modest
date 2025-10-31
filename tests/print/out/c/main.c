// tests/print/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>



int main() {
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


