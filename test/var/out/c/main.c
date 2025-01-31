
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#define _main_arr  {1, 2}
int32_t main_arr[2] = _main_arr;

static int32_t main_arr0[2] = _main_arr;
static int32_t main_arr1[2] = _main_arr;
static char *main_str = "Hello!";// -> *[]Char8


int main()
{
	int32_t x = 127;
	int32_t y = x + 1;

	printf("y = %i\n", y);

	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

