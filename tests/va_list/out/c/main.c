
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
	const int n = vsnprintf(/*4*/&buf[0], (size_t)strMaxLen, /*4*/format, va2);

	va_end(va2);

	return write(STDOUT_FILENO, (void *)&buf, (size_t)abs((int)n));

#undef strMaxLen
}


int main(void) {
	uint32_t k = 10;
	my_printf(/*4*/"My Printf Test %u\n", k);

	const char c = '$';
	char *const s = "Hi!";
	const int32_t i = (int32_t)-1;
	const uint32_t n = 123;
	const uint32_t x = 0x1234567F;

	my_printf(/*4*/"\x0\x0\n");
	my_printf(/*4*/"c = '%c'\n", (const char)c);
	my_printf(/*4*/"s = \"%s\"\n", /*4*/(char*)s);
	my_printf(/*4*/"i = %i\n", i);
	my_printf(/*4*/"n = %i\n", n);
	my_printf(/*4*/"x = 0x%x\n", x);

	return 0;
}


