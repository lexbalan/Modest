// tests/sizes/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"
#define CDECL
CDECL


int main() {
	printf("sizeof(Char) = %zu\n", sizeof(char));
	printf("sizeof(Short) = %zu\n", sizeof(short));
	printf("sizeof(Int) = %zu\n", sizeof(int));
	printf("sizeof(Long) = %zu\n", sizeof(long));
	printf("sizeof(LongLong) = %zu\n", sizeof(long long));
	printf("sizeof(Size) = %zu\n", sizeof(size_t));
	printf("sizeof(*Unit) = %zu\n", sizeof(void *));
	return 0;
}

