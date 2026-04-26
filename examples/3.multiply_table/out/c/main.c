
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void main_mtab(uint32_t n) {
	uint32_t m = 1U;
	while (m < 10U) {
		const uint32_t nm = n * m;
		printf("%u * %u = %u\n", n, m, nm);
		m = m + 1U;
	}
}

int main(void) {
	#define n (2 * 2)
	printf("multiply table for %d\n", (int32_t)n);
	main_mtab(n);
	return 0;
	#undef n
}

