// tests/sizes/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


int main() {
	printf("sizeof(char) = %zu\n", (size_t)sizeof(char));
	printf("sizeof(short) = %zu\n", (size_t)sizeof(short));
	printf("sizeof(int) = %zu\n", (size_t)sizeof(int));
	printf("sizeof(long) = %zu\n", (size_t)sizeof(long));
	printf("sizeof(long long) = %zu\n", (size_t)sizeof(long long));
	printf("sizeof(size_t) = %zu\n", (size_t)sizeof(size_t));
	printf("sizeof(void*) = %zu\n", (size_t)sizeof(void *));
	return 0;
}

