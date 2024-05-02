// test/va_list/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./print.h"





int main()
{
	print("Hello World!\n");

	const char c = '$';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 0x1234567F;

	print("\\{{\\}}\n");
	print("c = '{c}'\n", c);
	print("s = \"{s}\"\n", s);
	print("i = {i}\n", i);
	print("n = {n}\n", n);
	print("x = 0x{x}\n", x);

	return 0;
}

