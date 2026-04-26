
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

static void main_mtab(uint32_t n) {
	uint32_t m = 1U;
	while (m < 10U) {
		const uint32_t main_nm = n * m;
		printf("%u * %u = %u\n", n, m, main_nm);
		m = m + 1U;
	}
}

int main(void) {
	#define main_n (2 * 2)
	printf("multiply table for %d\n", (int32_t)main_n);
	main_mtab(main_n);
	return 0;
	#undef main_n
}

