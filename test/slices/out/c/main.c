// test/slices/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
	printf("test slices\n");

	//
	// by value
	//

	int32_t a[10];
	memcpy(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t[10]));

	const int32_t s1[2] = <slice>
