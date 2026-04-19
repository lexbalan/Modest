
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
static int32_t v[5][4] = {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}};
static int32_t u[5][4] = {{1, 2}, {3, 4}, {5, 6, 7}, {8, 9, 10, 11}, {12, 13}};
static char str1[3] = {'a', 'b', 'c'};
static char str2[3] = {'a', 'b', 'c'};
static char str3[3] = {'a', 'b', 'c'};

int32_t main(void) {
	if (__builtin_memcmp(&u, &v, sizeof(int32_t [5][4])) == 0) {
		printf("u == v\n");
	}
	return 0;
}

