// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


int32_t main();
int32_t sum(int32_t a, int32_t b);// test/pre/src/main.cm

//import "libc/stdio"

int32_t main()
{

	#define a  10
	#define b  20
	const int32_t s = sum(a, b);

	return 0;
}

#undef a
#undef b


int32_t sum(int32_t a, int32_t b)
{
	return a + b;
}

