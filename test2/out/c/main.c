// unicode support test

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>



int32_t main()
{
	printf("test2\n");
	int32_t a = 5;
	int32_t b = 7;
	int32_t arr[4];
	memcpy(&arr, &{1, 2, a, b}, sizeof(int32_t[4]));
	return 0;
}


