
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static int64_t sum64(int64_t a, int64_t b) {
	int64_t sum;
	__asm__ volatile (
		"add %0, %1, %2"
		: "=r" (sum)
		: "r" (a), "r" (b)
		: "cc"
	);
	return sum;
}


static int64_t sub64(int64_t a, int64_t b) {
	int64_t sub;
	__asm__ volatile (
		"sub %0, %1, %2"
		: "=r" (sub)
		: "r" (a), "r" (b)
		: "cc"
	);
	return sub;
}


static void sumsub64(int64_t a, int64_t b) {
	int64_t sum;
	int64_t sub;

	__asm__ volatile (
		"add %0, %2, %3\nsub %1, %2, %3\n"
		: "=&r" (sum), "=&r" (sub)
		: "r" (a), "r" (b)
		: "cc"
	);

	printf(/*4*/"sumsub64 sum = %lld\n", sum);
	printf(/*4*/"sumsub64 sub = %lld\n", sub);
}


int main(void) {
	printf(/*4*/"inline asm test\n");

	int64_t a = 10;
	int64_t b = 20;

	const int64_t sum = sum64(a, b);
	const int64_t sub = sub64(a, b);

	printf(/*4*/"sum(%lld, %lld) = %lld\n", a, b, sum);
	printf(/*4*/"sub(%lld, %lld) = %lld\n", a, b, sub);

	sumsub64(a, b);

	return 0;
}


