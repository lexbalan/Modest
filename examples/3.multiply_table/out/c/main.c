// examples/3.multiply_table/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static void mtab(uint32_t n) {
	uint32_t m = 1;
	// or
	//var m = 1   // by default integer var get system int type (-mint option)
	while (m < 10) {
		const uint32_t nm = n * m;
		printf("%u * %u = %u\n", n, m, nm);
		m = m + 1;
	}
}


int main(void) {
	#define n  (2 * 2)
	printf("multiply table for %d\n", (int32_t)n);
	mtab(n);
	return 0;

#undef n
}


