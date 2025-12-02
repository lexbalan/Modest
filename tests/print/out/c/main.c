
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./console.h"



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
	console_print("c = \"{c}\"\n", c);// c = "🐀"
	console_print("s = \"{s}\"\n", s);// s = "Hi!"
	console_print("i = {i}\n", i);// i = -1
	console_print("n = {n}\n", n);// n = 123
	console_print("x = 0x{x}\n", x);// x = 0x1234567F

	return 0;
}


