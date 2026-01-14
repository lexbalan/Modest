
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>

#include <stdarg.h>
#include <stdlib.h>


//include "lightfood/print"
//pragma c_include "./print.h"

static ssize_t my_printf(char *format, ...) {
	va_list va;
	va_list va2;

	va_copy(va2, va);

	va_start(va2, format);

	#define strMaxLen  (127 + 1)
	char buf[strMaxLen];
	const int n = vsnprintf((char *)&buf, (size_t)strMaxLen, format, va2);

	va_end(va2);

	return write(STDOUT_FILENO, (void *)&buf, (size_t)abs((int)n));

#undef strMaxLen
}


int main(void) {
	uint32_t k = 10;
	my_printf("My Printf Test %u\n", k);

	const char c = '$';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 0x1234567F;

	my_printf("\x0\x0\n");
	my_printf("c = '%c'\n", c);
	my_printf("s = \"%s\"\n", s);
	my_printf("i = %i\n", i);
	my_printf("n = %i\n", n);
	my_printf("x = 0x%x\n", x);

	return 0;
}


