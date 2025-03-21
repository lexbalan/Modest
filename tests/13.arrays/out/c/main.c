
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */

#define ARRCPY(dst, src, len) for (uint32_t i = 0; i < (len); i++) { \
	(*dst)[i] = (*src)[i]; \
}


//@attribute("c_no_print")
//import "misc/minmax"
//$pragma c_include "./minmax.h"

#define _constantArray  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
static const int32_t constantArray[10] = _constantArray;

static int32_t globalArray[10] = _constantArray;

static char arrayFromString[3] = "abc";

//var arrayOfChars = [Char8 "a", 'b', 'c']

static void f0(char *_x, char *sret_)
{
	char x[20];
	memcpy(x, _x, sizeof(char[20]));
	char local_copy_of_x[20];
	ARRCPY((&local_copy_of_x), (&x), (__lengthof(local_copy_of_x)));
	printf("f0(\"%s\")\n", &local_copy_of_x);

	// truncate array
	char mic[6];
	ARRCPY((&mic), (&x), (__lengthof(mic)));
	mic[5] = '\x0';

	printf("f0 mic = \"%s\"\n", &mic);

	// extend array
	char res[30];
	ARRCPY((&res), (&x), (__lengthof(res)));
	res[6] = 'M';
	res[7] = 'o';
	res[8] = 'd';
	res[9] = 'e';
	res[10] = 's';
	res[11] = 't';
	res[12] = '!';
	res[13] = '\x0';
	memcpy(sret_, &res, sizeof(char[30]));
}

#define _startSequence  {0xAA, 0x55, 0x02}
static const uint64_t startSequence[3] = _startSequence;
#define _stopSequence  {0x16}
static const uint64_t stopSequence[1] = _stopSequence;

static void test()
{
	// тестируем работу с локальным generic массивом
	uint64_t yy[6];
	ARRCPY((&yy), (&(uint64_t[6]){0xAA, 0x55, 0x02, 0x00, 0x00, 0x16	}), (__lengthof(yy)));
	int32_t i = 0;
	while (i < __lengthof(yy)) {
		const uint64_t y = yy[i];
		printf("yy[%i] = %i\n", i, y);
		i = i + 1;
	}
}

static int32_t a0[2][2][5] = (int32_t[2][2][5]){

	0, 1, 2, 3, 4,
	5, 6, 7, 8, 9,

	10, 11, 12, 13, 14,
	15, 16, 17, 18, 19
};

static int32_t a1[5] = (int32_t[5]){0, 1, 2, 3, 4};
static int32_t a2[5] = (int32_t[5]){5, 6, 7, 8, 9};
static int32_t *a3[2] = (int32_t *[2]){&a1, &a2};
static int32_t *(*a4[2])[2] = (int32_t *(*[2])[2]){&a3, &a3};
static int32_t *(*(*p0)[2])[2] = &a4;

static int32_t a10[10][10] = (int32_t[10][10]){
	1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
	11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
	31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
	51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
	61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
	71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
	81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
	91, 92, 93, 94, 95, 96, 97, 98, 99, 100
};

static void test_arrays()
{
	int32_t i;
	int32_t j;
	int32_t k;

	i = 0;
	while (i < 10) {
		j = 0;
		while (j < 10) {
			a10[i][j] = a10[i][j] * 2;
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < 10) {
		j = 0;
		while (j < 10) {
			printf("a10[%d][%d] = %d\n", i, j, a10[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, a0[i][j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
	//
	//
	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 5) {
			printf("a3[%d][%d] = %d\n", i, j, a3[i][j]);
			j = j + 1;
		}
		i = i + 1;
	}
	//
	//
	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("a3[%d][%d][%d] = %d\n", i, j, k, (*a4[i])[j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}

	i = 0;
	while (i < 2) {
		j = 0;
		while (j < 2) {
			k = 0;
			while (k < 5) {
				printf("p0[%d][%d][%d] = %d\n", i, j, k, (*(*p0)[i])[j][k]);
				k = k + 1;
			}
			j = j + 1;
		}
		i = i + 1;
	}
}

int main()
{
	// generic array [4]Char8 will be implicit casted to [10]Char8

	char em[30];
	f0("Hello World!", &em);
	printf("em = %s\n", &em);

	int32_t i = 0;
	while (i < 10) {
		const int32_t a = globalArray[i];
		printf("globalArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t localArray[3];
	ARRCPY((&localArray), (&(int32_t[3]){4, 5, 6	}), (__lengthof(localArray)));

	i = 0;
	while (i < 3) {
		const int32_t a = localArray[i];
		printf("localArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t *globalArrayPtr;
	globalArrayPtr = (int32_t *)&globalArray;

	i = 0;
	while (i < 3) {
		const int32_t a = globalArrayPtr[i];
		printf("globalArrayPtr[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t *localArrayPtr;
	localArrayPtr = (int32_t *)&localArray;

	i = 0;
	while (i < 3) {
		const int32_t a = localArrayPtr[i];
		printf("localArrayPtr[%i] = %i\n", i, a);
		i = i + 1;
	}

	// assign array to array 1
	// (with equal types)
	int32_t a[3];
	ARRCPY((&a), (&(int32_t[3]){1, 2, 3	}), (__lengthof(a)));
	printf("a[0] = %i\n", a[0]);
	printf("a[1] = %i\n", a[1]);
	printf("a[2] = %i\n", a[2]);

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	int32_t b[3];
	ARRCPY((&b), (&a), (__lengthof(b)));
	printf("b[0] = %i\n", b[0]);
	printf("b[1] = %i\n", b[1]);
	printf("b[2] = %i\n", b[2]);

	// check equality between two arrays (by value)
	if (memcmp(&a, &b, sizeof(int32_t[3])) == 0) {
		printf("a == b\n");
	} else {
		printf("a != b\n");
	}

	// assign array to array 2
	// (with array extending)
	int32_t c[3];
	ARRCPY((&c), (&(int32_t[3]){10, 20, 30	}), (__lengthof(c)));
	int32_t d[6];
	ARRCPY((&d), (&c), (__lengthof(d)));
	printf("d[0] = %i\n", d[0]);
	printf("d[1] = %i\n", d[1]);
	printf("d[2] = %i\n", d[2]);
	printf("d[3] = %i\n", d[3]);
	printf("d[4] = %i\n", d[4]);
	printf("d[5] = %i\n", d[5]);


	// check equality between two arrays (by pointer)
	int32_t *const pa = &a;
	int32_t *const pb = &b;

	if (memcmp(pa, pb, sizeof(int32_t[3])) == 0) {
		printf("*pa == *pb\n");
	} else {
		printf("*pa != *pb\n");
	}


	//
	// Check assination local literal array
	//


	//let aa = [111] + [222] + [333]
	// cons literal array from var items
	int int100 = 100;
	int int200 = 200;
	int int300 = 300;
	// immutable, non immediate value (array)
	const int __init_array[3] = {int100, int200, int300	};

	// check local literal array assignation to local array
	int32_t e[4];
	memset(&e, 0, sizeof(int32_t[4]));
	ARRCPY((&e), (&__init_array), (__lengthof(e)));
	printf("e[0] = %i\n", e[0]);
	printf("e[1] = %i\n", e[1]);
	printf("e[2] = %i\n", e[2]);

	// check local literal array assignation to global array
	ARRCPY((&globalArray), (&__init_array), (__lengthof(globalArray)));
	printf("globalArray[%i] = %i\n", 0, globalArray[0]);
	printf("globalArray[%i] = %i\n", 1, globalArray[1]);
	printf("globalArray[%i] = %i\n", 2, globalArray[2]);


	memset(&globalArray, 0, sizeof(int32_t[10]));


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	int32_t ax = 10;
	int32_t bx = 20;
	int32_t cx = 30;
	const int32_t dx = 40;

	const int32_t __y[4] = {ax, bx, cx, dx	};

	ax = 111;
	bx = 222;
	cx = 333;

	printf("y[%i] = %i (must be 10)\n", 0, __y[0]);
	printf("y[%i] = %i (must be 20)\n", 1, __y[1]);
	printf("y[%i] = %i (must be 30)\n", 2, __y[2]);
	printf("y[%i] = %i (must be 40)\n", 3, __y[3]);

	if (memcmp(&__y, &(int32_t[4]){10, 20, 30, 40	}, sizeof(int32_t[4])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}


	char sa[5];
	ARRCPY((&sa), (&"LoHi!"), (5));

	if (memcmp((char(*)[4 - 2])&sa[2], "Hi", sizeof(char[4 - 2])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	test_arrays();

	return 0;
}

