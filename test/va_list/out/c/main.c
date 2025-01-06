// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include "main.h"




static ssize_t my_printf(char *format, ...)
{
	va_list va;
	va_list va2;

	va_copy(va2, va);

	va_start(va2, format);

	#define __strMaxLen  (127 + 1)
	char buf[__strMaxLen];
	memset(&buf, 0, sizeof buf);
	int n = vsnprintf(&buf[0], __strMaxLen, format, va2);

	va_end(va2);

	return write(STDOUT_FILENO, &buf[0], ((size_t)(uint32_t)n));

#undef __strMaxLen
}


int main()
{
	int32_t k = 10;
	my_printf("My Printf Test %d\n", k);

	char c = '$';
	char *s = "Hi!";
	int32_t i = (int32_t)-1;
	uint32_t n = 123;
	uint32_t x = 0x1234567F;

	my_printf("\x0\x0\n");
	my_printf("c = '%c'\n", c);
	my_printf("s = \"%s\"\n", s);
	my_printf("i = %i\n", i);
	my_printf("n = %i\n", n);
	my_printf("x = 0x%x\n", x);

	return 0;
}

