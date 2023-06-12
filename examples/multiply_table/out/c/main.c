
#include <stdint.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

void mtab(uint32_t n) {
	uint32_t m;
	m = 1;
	while (m < 10) {
		uint32_t nm = n * m;
		printf("%d * %d = %d\n", n, m, nm);
		m = m + 1;
	}
}

int main() {
	Int n = 2;
	printf("multiply table for %d\n", n);
	mtab(n);
	return 0;
}

