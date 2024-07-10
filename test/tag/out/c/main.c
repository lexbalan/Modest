// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




static uint32_t x;

//@undef("x")
//var x: Int32


static uint32_t y;


int main()
{
	printf("tag test\n");

	int len;
	len = 5;
	uint32_t a[len];

	a[0] = 100;
	a[1] = 200;
	a[2] = 300;

	printf("a[0] = %d\n", a[0]);
	printf("a[1] = %d\n", a[1]);
	printf("a[2] = %d\n", a[2]);

	//a = [10, 20, 30, 40, 50]

	return 0;
}

