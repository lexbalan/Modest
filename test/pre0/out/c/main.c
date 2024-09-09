// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Point2 {
	int32_t x;
	int32_t y;
};
void main_init();



void main_init()
{
	printf("init!\n");
}

lib_Int main()
{
	main_init();

	#define __a  10
	#define __b  20
	const lib_Int s = lib_mid(__a, __b);

	printf("s = %d\n", s);

	// access to private value
	//let x = lib.div(a, b)

	main_Point2 p;
	p = (main_Point2){.x = 10, .y = 20};
	lib_printPoint(*(lib_Point *)&p);

	return 0;
}

#undef __a
#undef __b

