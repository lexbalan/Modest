
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
#include <stdio.h>


static void main_mtab(uint32_t n)
{
	uint32_t m = 1;
	// or
	//var m = 1   // by default integer var get system int type (-mint option)
	while (m < 10) {
		uint32_t nm = n * m;
		printf("%u * %u = %u\n", n, m, nm);
		m = m + 1;
	}
}


int main()
{
	#define __n  (2 * 2)
	printf("multiply table for %d\n", (int32_t)__n);
	main_mtab(__n);
	return 0;

#undef __n
}

