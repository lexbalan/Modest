
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static void foo(int32_t a, int64_t b) {
	return;
}


int main(void) {
	int32_t a;
	int64_t b;
	foo((int32_t)1, (int64_t)2);
	foo(a + (int32_t)1, b - (int64_t)1);
	(int4_t)(1 + 2) - 3 * 4;
	return (int)0;
}


