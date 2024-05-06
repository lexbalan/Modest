// test/named_args/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int32_t named_args_test(int32_t a, int32_t b, int32_t c)
{
	return (a - b) * c;
}


int main()
{
	printf("test named_args\n");

	#define a  25
	#define b  15
	#define c  3

	const int32_t x = named_args_test(a, b, c);

	if (x == (a - b) * c) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
#undef a
#undef b
#undef c
}

