// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include "main.h"



int32_t main();


int32_t main()
{
	const uint32_t c = U'#';
	main_print("%c", c);
	return 0;
}

void main_print(char *form, ...)
{
	va_list va;
	va_start(va, form);

	/*unsafe Char8*/
	const uint32_t c = va_arg(va, uint32_t);
	printf("CC32 = %d\n", c);
	printf("CC8 = %d\n", (char)c);

	va_end(va);
}

