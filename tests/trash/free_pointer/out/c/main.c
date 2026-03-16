
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

int32_t main(void) {
	bool a;
	int32_t b;
	int64_t c;
	void *freePointer;
	freePointer = (void *)&a;
	freePointer = (void *)&b;
	freePointer = (void *)&c;
	*(int64_t *)freePointer = 123456789123456789LL;
	printf("c = 0x%llX\n", c);
	int64_t *const px = (int64_t *)freePointer;
	const int64_t x = *px;
	printf("x = 0x%llX\n", x);
	return 0;
}

