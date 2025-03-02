// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include "main.h"



int32_t main();


int32_t main()
{
	main_xxx("", 10);
	//let c = Char32 "#"
	//print("%c", c)
	return 0;
}

void main_xxx(char *form, ...)
{
	va_list va;
	va_start(va, form);
	main_yyy(1, "", va);
	va_end(va);
}

void main_yyy(int32_t fd, char *form, va_list va)
{
	const uint32_t x = va_arg(va, uint32_t);
	printf("x = %d\n", x);
	//var strbuf: [256]Char8
	//let n = vsprint(&strbuf, form, va)
	//strbuf[n] = '\x0'
	//write(fd, &strbuf, SizeT n)
}

