// tests/sizes/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


int main() {
	size_t sz;
	size_t n = sz;

	printf("sizeof(char) = %zu\n", sizeof(char));
	printf("sizeof(short) = %zu\n", sizeof(short));
	printf("sizeof(int) = %zu\n", sizeof(int));
	printf("sizeof(long) = %zu\n", sizeof(long));
	printf("sizeof(long long) = %zu\n", sizeof(long long));
	printf("sizeof(size_t) = %zu\n", sizeof(size_t));
	printf("sizeof(void*) = %zu\n", sizeof(void *));
	return 0;
}

