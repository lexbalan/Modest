
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define MAIN_ARR {1, 2}
static int32_t main_arr0[2] = {1, 2};
static int32_t main_arr1[2] = {1, 2};
static char *main_str = "Hello!";
// -> *[]Char8

int main(void) {
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

