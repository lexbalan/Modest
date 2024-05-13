// test/1.hello_world/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define arr  {1, 2}
const int32_t _arr[2] = arr;
static int32_t arr0[2] = {1, 2};
static int32_t arr1[2] = {1, 2};
static char *str = "Hello!";// -> *[]Char8


int main()
{
	int32_t x;
	x = 127;
	int32_t y;
	y = x + 1;

	printf("y = %i\n", y);

	if (y == 128) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

