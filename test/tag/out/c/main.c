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


	uint32_t y[5];
	y[0] = 50;


	int len;
	len = 5;
	uint32_t a[len];


	a[0] = 100;
	a[1] = 200;
	a[2] = 300;

	printf("a[0] = %d\n", a[0]);
	printf("a[1] = %d\n", a[1]);
	printf("a[2] = %d\n", a[2]);

	/*
	len = 22
	let size = sizeof(a)
	printf("sizeof(a) == %lu", size)
	*/

	memcpy(&a, &(uint32_t[]){1, 2, 3, 4, 5}, sizeof(uint32_t[len]));

	printf("a[0] = %d\n", a[0]);
	printf("a[1] = %d\n", a[1]);
	printf("a[2] = %d\n", a[2]);

	return 0;
}

