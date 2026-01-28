
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */
#define ARRCPY(dst, src, len) \
	do { \
		uint32_t _len = (uint32_t)(len); \
		for (uint32_t _i = 0; _i < _len; _i++) { \
			(*(dst))[_i] = (*(src))[_i]; \
		} \
	} while (0)
#include <stdlib.h>


static void array_print(int32_t(*pa)[], uint32_t len) {
	uint32_t i = 0;
	while (i < len) {
		printf(/*4*/"a[%d] = %d\n", i, (*pa)[i]);
		i = i + 1;
	}
}


int main(void) {
	printf(/*4*/"test slices\n");

	//
	// by value
	//

	int32_t a[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

	int32_t s1[2 - 1];
	memcpy(&s1, (int32_t(*)[2 - 1])&a[1], sizeof(int32_t[2 - 1]));
	uint32_t i = 0;
	while (i < LENGTHOF(s1)) {
		printf(/*4*/"s1[%d] = %d\n", i, s1[i]);
		i = i + 1;
	}

	printf(/*4*/"--------------------------------------------\n");

	//
	// by ptr
	//

	int32_t(*const pa)[10] = &a;
	int32_t s2[8 - 5];
	memcpy(&s2, (int32_t(*)[8 - 5])&(*pa)[5], sizeof(int32_t[8 - 5]));
	i = 0;
	while (i < LENGTHOF(s2)) {
		printf(/*4*/"s2[%d] = %d\n", i, s2[i]);
		i = i + 1;
	}

	printf(/*4*/"--------------------------------------------\n");

	int32_t vs1[2 - 1];
	memcpy(&vs1, &s1, sizeof(int32_t[2 - 1]));
	int32_t vs2[8 - 5];
	memcpy(&vs2, &s2, sizeof(int32_t[8 - 5]));

	#define ax  2
	#define bx  6
	ARRCPY((int32_t(*)[bx - ax])&a[ax], &((int8_t[4]){10, 20, 30, 40}), bx - ax);

	i = 0;
	while (i < LENGTHOF(a)) {
		printf(/*4*/"a[%d] = %d\n", i, a[i]);
		i = i + 1;
	}

	printf(/*4*/"--------------------------------------------\n");

	int32_t s[10] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};

	memset((int32_t(*)[5 - 2])&s[2], 0, sizeof(int32_t[5 - 2]));

	i = 0;
	while (i < LENGTHOF(s)) {
		printf(/*4*/"s[%d] = %d\n", i, (uint32_t)abs((int)s[i]));
		i = i + 1;
	}

	printf(/*4*/"--------------------------------------------\n");
	printf(/*4*/"test pointer to slice\n");

	#define aa  2
	#define bb  8

	int32_t(*const p)[bb - aa] = &s[aa];
	array_print(/*ParamIsPtr2Arr*/p, bb - aa);

	printf(/*4*/"--------------------------------------------\n");

	(*p)[0] = 123;

	array_print(/*ParamIsPtr2Arr*/p, bb - aa);

	printf(/*4*/"--------------------------------------------\n");
	printf(/*4*/"slice of pointer to open array\n");

	// за каким то хером это работает, то что мне сейчас нужно
	// но тут еще куча работы впереди

	int32_t(*pw)[] = (int32_t(*)[])&s;

	printf(/*4*/"before\n");
	array_print(/*ParamIsPtr2Arr*/pw, 10);

	int32_t ind = 1;

	pw = &(*pw)[ind];

	printf(/*4*/"after\n");
	array_print(/*ParamIsPtr2Arr*/pw, 10);

	printf(/*4*/"--------------------------------------------\n");
	printf(/*4*/"zero slice by var\n");
	// NOT WORKED NOW

	int32_t ss[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

	int32_t k = 4;
	int32_t j = 7;
	memset((int32_t(*)[j - k])&ss[k], 0, sizeof(int32_t[j - k]));
	array_print(/*ParamIsPtr2Arr*/&ss, 10);

	printf(/*4*/"--------------------------------------------\n");
	printf(/*4*/"copy slice by var\n");

	int32_t src[5] = {10, 20, 30, 40, 50};
	int32_t dst[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

	// test with let
	#define i1  3
	#define j1  8
	ARRCPY((int32_t(*)[j1 - i1])&dst[i1], &((int8_t[5]){11, 22, 33, 44, 55}), j1 - i1);

	array_print(/*ParamIsPtr2Arr*/&dst, 10);

	//	printf("--------------------------------------------\n")
	//
	//	var dst2 = []Int32 [00, 10, 20, 30, 40, 50, 60, 70, 80, 90]
	//
	//	var axx = Nat8 111
	//	var bxx = Nat8 222
	//
	//	// FIXIT: test with var
	//	// ARRCPY не умеет копировать generic массив, исправь это
	//	var i2: Int32 = 3
	//	var j2: Int32 = 5
	//	dst2[i2:j2] = [Int32 axx, Int32 bxx]
	//
	//	array_print(&dst2, 10)

	return 0;

#undef ax
#undef bx
#undef aa
#undef bb
#undef i1
#undef j1
}


