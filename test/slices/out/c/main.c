// test/slices/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
	printf("test slices\n");

	//
	// by value
	//

	int32_t a[10];
	memcpy(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t[10]));

	const int32_t s1[2] = &a[1];
	int32_t i;
	i = 0;
	while (i < (sizeof(s1) / sizeof(s1[0]))) {
		printf("s1[%d] = %d\n", i, s1[i]);
		i = i + 1;
	}

	//
	// by ptr
	//

	int32_t *const pa = (int32_t *)&a;

	const int32_t s2[4] = &pa[5];
	i = 0;
	while (i < (sizeof(s2) / sizeof(s2[0]))) {
		printf("s2[%d] = %d\n", i, s2[i]);
		i = i + 1;
	}

	return 0;
}

