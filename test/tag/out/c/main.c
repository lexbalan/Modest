// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include "main.h"





static void print(char *form, ...)
{
	va_list va;
	va_start(va, form);

	const uint32_t c = va_arg(va, uint32_t);
	printf("CC32 = %d\n", c);
	printf("CC8 = %d\n", (char)c);

	va_end(va);
}

int32_t main()
{
	const uint32_t c = U'#';
	print("%c", c);

	main_Rec0 r0;
	main_Rec1 r1;

	r0.p = (main_Rec1 *)&r1;
	r1.p = (main_Rec0 *)&r0;

	return 0;
}

