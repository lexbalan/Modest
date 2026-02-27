
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static void foo(int32_t a, int64_t b) {
	return;
}


#define C  15

int main(void) {
	int32_t a;
	int64_t b;
	foo((int32_t)1, (int64_t)2);
	foo(a + (int32_t)1, b - (int64_t)c);
	(int4_t)(1 + 2) - 3 * 4;
	int32_t arr[3] = (int32_t [3]){1, 2, 3};
	arr[(int32_t)1];
	if (a < (int32_t)1 && b > (int64_t)12 || c <= 5 && !1 < 0) {
		uint32_t u;
		uint32_t v;
		u | v & u ^ v;
		u << 10;v >> 20;
		int32_t *const pa = &a;
		*pa;
		((int64_t)a + b);
		+a;
		-a;
	}
	return (int)0;
}


