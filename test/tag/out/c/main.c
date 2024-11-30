// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>
#include "main.h"






struct Rec1;
typedef struct Rec1 Rec1;

struct Rec0 {
	Rec1 *p;
};
typedef struct Rec0 Rec0;

struct Rec1 {
	Rec0 *p;
};


void main_print(char *form, ...)
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
	main_print("%c", c);

	Rec0 r0;
	Rec1 r1;

	r0.p = (Rec1 *)&r1;
	r1.p = (Rec0 *)&r0;



	return 0;
}

