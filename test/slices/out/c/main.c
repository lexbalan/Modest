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

	/*let slice*/
	int32_t s1[2];
	memcpy(&s1, &a[1], sizeof(int32_t[2]));
	/*end let slice*/
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

	/*let slice*/
	int32_t s2[4];
	memcpy(&s2, &pa[5], sizeof(int32_t[4]));
	/*end let slice*/
	i = 0;
	while (i < (sizeof(s2) / sizeof(s2[0]))) {
		printf("s2[%d] = %d\n", i, s2[i]);
		i = i + 1;
	}

	#define ax  2
	#define bx  5
	memcpy(&a[2], &(int32_t[4]){10, 20, 30, 40}, sizeof(int32_t[4]));

	i = 0;
	while (i < (sizeof(a) / sizeof(a[0]))) {
		printf("a[%d] = %d\n", i, a[i]);
		i = i + 1;
	}


	printf("--------------------------------------------\n");

	int8_t s[9];
	memcpy(&s, &(int8_t[9]){10, 20, 30, 40, 50, 60, 70, 80, 90}, sizeof(int8_t[9]));

	memset(&s[2], 0, sizeof(int8_t[4]));

	i = 0;
	while (i < (sizeof(s) / sizeof(s[0]))) {
		printf("s[%d] = %d\n", i, ((uint32_t)(uint8_t)s[i]));
		i = i + 1;
	}

	return 0;

	// undef local macro
	#undef ax
	#undef bx
}

