
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

static ssize_t main_my_printf(char *format, ...) {
	va_list va;
	va_list va2;
	va_copy(va2, va);
	va_start(va2, format);
	#define main_strMaxLen (127 + 1)
	char buf[main_strMaxLen];
	const int main_n = vsnprintf(buf, (size_t)main_strMaxLen, format, va2);
	va_end(va2);
	return write(STDOUT_FILENO, buf, (size_t)abs(main_n));
	#undef main_strMaxLen
}

int main(void) {
	uint32_t k = 10U;
	main_my_printf("My Printf Test %u\n", k);
	const char main_c = '$';
	char *const main_s = "Hi!";
	const int32_t main_i = (int32_t)-1;
	const uint32_t main_n = 123U;
	const uint32_t main_x = 305419903U;
	main_my_printf("\x0\x0\n");
	main_my_printf("c = '%c'\n", main_c);
	main_my_printf("s = \"%s\"\n", main_s);
	main_my_printf("i = %i\n", main_i);
	main_my_printf("n = %i\n", main_n);
	main_my_printf("x = 0x%x\n", main_x);
	return 0;
}

