// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




static uint32_t x;

static int32_t x;


int main()
{
	printf("tag test");

	x = -1;

	//let s = sum(10, 20)

	//var s : Tag = #justSymbol

	return 0;
}


int32_t sum(int32_t a, int32_t b)
{
	return a + b;
}

