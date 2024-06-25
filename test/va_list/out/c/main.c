// test/va/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>
#include <unistd.h>
#include "./print.h"




ssize_t my_printf(char *format, ...)
{
	va_list va;
	va_list va2;

	va_copy(va2, va);

	va_start(va2, format);

	#define strMaxLen  (127 + 1)
	char buf[strMaxLen];
	const int n = vsnprintf((char *)&buf, strMaxLen, format, va2);

	va_end(va2);

	return write(STDOUT_FILENO, (char *)&buf, ((size_t)(uint32_t)n));
}

#undef strMaxLen


int main()
{
	//print("Hello World!\n")

	int32_t k;
	k = 10;
	my_printf("My Printf Test %d\n", k);

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

