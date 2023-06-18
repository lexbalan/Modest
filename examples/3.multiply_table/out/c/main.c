
#include <stdint.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

void mtab(uint32_t n) {
	uint32_t m;
	m = 1;
	while(m < 10) {
		const uint32_t nm = n * m;
		printf("%d * %d = %d\n", n, m, nm);
		m = m + 1;
	}
}

int32_t main() {
	const int8_t n = 2;
	printf("multiply table for %d\n", n);
	mtab(n);
	return 0;
}

