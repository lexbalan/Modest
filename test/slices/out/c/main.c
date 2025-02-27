
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */



static void array_print(int32_t *pa, int32_t len)
{
	int32_t i = 0;
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
	memcpy(&a, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof a);

	int32_t s1[2 - 1];
	memcpy(&s1, &a[1], sizeof s1);
	int32_t i = 0;
	while (i < __lengthof(s1)) {
		printf("s1[%d] = %d\n", i, s1[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");

	//
	// by ptr
	//

	int32_t *const pa = &a;
	int32_t s2[8 - 5];
	memcpy(&s2, &pa[5], sizeof s2);
	i = 0;
	while (i < __lengthof(s2)) {
		printf("s2[%d] = %d\n", i, s2[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");

	int32_t vs1[2 - 1];
	memcpy(&vs1, &s1, sizeof vs1);
	int32_t vs2[8 - 5];
	memcpy(&vs2, &s2, sizeof vs2);

	#define __ax  2
	#define __bx  6
	memcpy(&a[__ax], &(int32_t[__bx - __ax]){10, 20, 30, 40	}, sizeof a[__ax]);

	i = 0;
	while (i < __lengthof(a)) {
		printf("a[%d] = %d\n", i, a[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");

	int32_t s[10];
	memcpy(&s, &(int32_t[10]){10, 20, 30, 40, 50, 60, 70, 80, 90, 100	}, sizeof s);

	memset(&s[2], 0, sizeof s[2]);

	i = 0;
	while (i < __lengthof(s)) {
		printf("s[%d] = %d\n", i, (uint32_t)s[i]);
		i = i + 1;
	}

	printf("--------------------------------------------\n");
	printf("test pointer to slice\n");

	#define __aa  2
	#define __bb  8

	int32_t *const p = &s[__aa];
	array_print(p, __lengthof(*p));

	printf("--------------------------------------------\n");

	p[0] = 123;

	array_print(p, __lengthof(*p));

	printf("--------------------------------------------\n");
	printf("slice of pointer to open array\n");

	// за каким то хером это работает, то что мне сейчас нужно
	// но тут еще куча работы впереди

	int32_t *pw = (int32_t *)&s;

	printf("before\n");
	array_print(pw, 10);

	int32_t ind = 1;

	pw = &pw[ind];

	printf("after\n");
	array_print(pw, 10);

	printf("--------------------------------------------\n");
	printf("zero slice by var\n");
	// NOT WORKED NOW

	int32_t ss[10];
	memcpy(&ss, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof ss);

	int32_t k = 4;
	int32_t j = 7;
	memset(&ss[k], 0, sizeof ss[k]);
	array_print((int32_t *)&ss, 10);

	printf("--------------------------------------------\n");
	printf("copy slice by var\n");

	int32_t src[5];
	memcpy(&src, &(int32_t[5]){10, 20, 30, 40, 50	}, sizeof src);
	int32_t dst[10];
	memcpy(&dst, &(int32_t[10]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9	}, sizeof dst);

	// test with let
	#define __i1  3
	#define __j1  8
	memcpy(&dst[__i1], &(int32_t[__j1 - __i1]){11, 22, 33, 44, 55	}, sizeof dst[__i1]);

	array_print((int32_t *)&dst, 10);

	printf("--------------------------------------------\n");

	int32_t dst2[10];
	memcpy(&dst2, &(int32_t[10]){0, 10, 20, 30, 40, 50, 60, 70, 80, 90	}, sizeof dst2);

	uint8_t axx = 111;
	uint8_t bxx = 222;

	// test with var
	int32_t i2 = 3;
	int32_t j2 = 5;
	memcpy(&dst2[i2], &{(int32_t)axx, (int32_t)bxx	}, sizeof dst2[i2]);

	array_print((int32_t *)&dst2, 10);

	return 0;

#undef __ax
#undef __bx
#undef __aa
#undef __bb
#undef __i1
#undef __j1
}

