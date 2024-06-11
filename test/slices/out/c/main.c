// test/slices/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



void array_print(int32_t *pa, int32_t len)
{
	int32_t i;
	i = 0;
	while (i < len) {
		printf("a[%d] = %d\n", i, pa[i]);
		i = i + 1;
	}
}


int main()
{
	printf("test slices\n");

	//
	// by value
	//

	int32_t a[10];
	memcpy(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, sizeof(int32_t[10]));

	int32_t s1[2 - 1 + 1];
	memcpy(&s1, &a[1], sizeof(int32_t[2 - 1 + 1]));
	int32_t i;
	i = 0;
	while (i < (2 - 1 + 1)) {
		printf("s1[%d] = %d\n", i, s1[i]);
		i = i + 1;
	}

	//
	// by ptr
	//

	int32_t *const pa = (int32_t *)&a;
	int32_t s2[8 - 5 + 1];
	memcpy(&s2, &pa[5], sizeof(int32_t[8 - 5 + 1]));
	i = 0;
	while (i < (8 - 5 + 1)) {
		printf("s2[%d] = %d\n", i, s2[i]);
		i = i + 1;
	}

	#define ax  2
	#define bx  5
	memcpy(&a[ax], &(int32_t[bx - ax + 1]){10, 20, 30, 40}, sizeof(int32_t[bx - ax + 1]));

	i = 0;
	while (i < (sizeof(a) / sizeof(a[0]))) {
		printf("a[%d] = %d\n", i, a[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");

	int32_t s[10];
	memcpy(&s, &(int32_t[10]){10, 20, 30, 40, 50, 60, 70, 80, 90, 100}, sizeof(int32_t[10]));

	memset(&s[2], 0, sizeof(int32_t[5 - 2 + 1]));

	i = 0;
	while (i < (sizeof(s) / sizeof(s[0]))) {
		printf("s[%d] = %d\n", i, (uint32_t)s[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");
	printf("test pointer to slice\n");

	#define aa  2
	#define bb  8

	int32_t *const p = (int32_t *)&s[aa];
	array_print(p, (bb - aa + 1));

	printf("--------------------------------------------\n");

	p[0] = 123;

	array_print(p, (bb - aa + 1));



	printf("--------------------------------------------\n");
	printf("slice of pointer to open array\n");

	// за каким то хером это работает, то что мне сейчас нужно
	// но тут еще куча работы впереди

	int32_t *pw;
	pw = (int32_t *)(int32_t *)&s;

	printf("before\n");
	array_print(pw, 10);

	pw = (int32_t *)&pw[1];

	printf("after\n");
	array_print(pw, 10);

	return 0;
}

#undef ax
#undef bx
#undef aa
#undef bb

