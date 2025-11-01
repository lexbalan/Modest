// tests/arrays/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


// Что можно делать с массивом
//   1.1 Создать без инициализации
//   1.2 Создать и проинициализировать пустым литералом
//   1.3 Создать и проинициализировать generic литералом
//   1.4 Создать и проинициализировать non-generic литералом
//
//   2.1 Присвоить массив массиву (константу, переменную)
//   2.2 Передать в функцию
//   2.3 Вернуть из функции
//
//   3.1 Сохранить значение в ячейку массива
//   3.2 Загрузить значение из ячейки массива
//
//   4.1 Загрузить срез (подмассив)
//   4.2 Сохранить срез (подмассив)
//
//   5.1 Получить длину массива (в элементах)
//   5.2 Получить размер массива (в байтах)
//
//   6.1 Создать VLA массив

#define CONSTANT_ARRAY  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

static int32_t globalArray[10] = CONSTANT_ARRAY;

static char arrayFromString[3] = "abc";

//var arrayOfChars = [Char8 "a", 'b', 'c']

static void f0(char *_x, char *sret_) {
	char x[20];
	memcpy(x, _x, sizeof(char[20]));
	char local_copy_of_x[20];
	memcpy(&local_copy_of_x, &x, sizeof(char[20]));
	printf("f0(\"%s\")\n", (char *)&local_copy_of_x);

	// truncate array
	char mic[6];
	memcpy(&mic, (char(*)[6 - 0])&x[0], sizeof(char[6]));
	mic[5] = '\x0';

	printf("f0 mic = \"%s\"\n", (char *)&mic);

	// extend array
	char res[30];
	memcpy((char(*)[20 - 0])&res[0], &x, sizeof(char[20 - 0]));
	memset((char(*)[30 - 20])&res[20], 0, sizeof(char[30 - 20]));

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


#define START_SEQUENCE  {0xAA, 0x55, 0x2}
#define STOP_SEQUENCE  {0x16}

static void test(void) {
	// тестируем работу с локальным generic массивом
	uint8_t yy[6] = {0xAA, 0x55, 0x2, 0x0, 0x0, 0x16};
	uint32_t i = 0;
	while (i < LENGTHOF(yy)) {
		const uint8_t y = yy[i];
		printf("yy[%i] = %u\n", i, (uint32_t)y);
		i = i + 1;
	}
}


static int32_t a0[2][2][5] = {
	{
	{0, 1, 2, 3, 4},
	{5, 6, 7, 8, 9}},
	{
	{10, 11, 12, 13, 14},
	{15, 16, 17, 18, 19}}
};

static int32_t a1[5] = {0, 1, 2, 3, 4};
static int32_t a2[5] = {5, 6, 7, 8, 9};
static int32_t *a3[2] = {&a1, &a2};
static int32_t *(*a4[2])[2] = {&a3, &a3};
static int32_t *(*(*p0)[2])[2] = &a4;

static int32_t a10[10][10] = {
	{1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
	{11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
	{21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
	{31, 32, 33, 34, 35, 36, 37, 38, 39, 40},
	{41, 42, 43, 44, 45, 46, 47, 48, 49, 50},
	{51, 52, 53, 54, 55, 56, 57, 58, 59, 60},
	{61, 62, 63, 64, 65, 66, 67, 68, 69, 70},
	{71, 72, 73, 74, 75, 76, 77, 78, 79, 80},
	{81, 82, 83, 84, 85, 86, 87, 88, 89, 90},
	{91, 92, 93, 94, 95, 96, 97, 98, 99, 100}
};

static void test_arrays(void) {
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


int main(void) {
	// generic array [4]Char8 will be implicit casted to [10]Char8

	char em[30];
	f0("Hello World!", (char *)&em);
	printf("em = %s\n", (char *)&em);

	uint32_t i = 0;
	while (i < 10) {
		const int32_t a = globalArray[i];
		printf("globalArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t localArray[3] = {4, 5, 6};

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
	int32_t a[3] = {1, 2, 3};
	printf("a[0] = %i\n", a[0]);
	printf("a[1] = %i\n", a[1]);
	printf("a[2] = %i\n", a[2]);

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	int32_t b[3];
	memcpy(&b, &a, sizeof(int32_t[3]));
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
	int32_t c[3] = {10, 20, 30};

	int32_t d[6];
	memcpy((int32_t(*)[3 - 0])&d[0], &c, sizeof(int32_t[3 - 0]));
	memset((int32_t(*)[6 - 3])&d[3], 0, sizeof(int32_t[6 - 3]));

	printf("d[0] = %i\n", d[0]);
	printf("d[1] = %i\n", d[1]);
	printf("d[2] = %i\n", d[2]);
	printf("d[3] = %i\n", d[3]);
	printf("d[4] = %i\n", d[4]);
	printf("d[5] = %i\n", d[5]);

	// check equality between two arrays (by pointer)
	int32_t *const pa = (int32_t *)&a;
	int32_t *const pb = (int32_t *)&b;

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
	int init_array[3] = {int100, int200, int300};

	// check local literal array assignation to local array
	int32_t e[4];
	memcpy(&e, &init_array, sizeof(int32_t[4]));
	printf("e[0] = %i\n", e[0]);
	printf("e[1] = %i\n", e[1]);
	printf("e[2] = %i\n", e[2]);

	// check local literal array assignation to global array
	memcpy(&globalArray, &init_array, sizeof(int32_t[10]));
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

	int32_t y[4] = {ax, bx, cx, dx};

	ax = 111;
	bx = 222;
	cx = 333;

	printf("y[%i] = %i (must be 10)\n", 0, y[0]);
	printf("y[%i] = %i (must be 20)\n", 1, y[1]);
	printf("y[%i] = %i (must be 30)\n", 2, y[2]);
	printf("y[%i] = %i (must be 40)\n", 3, y[3]);

	if (memcmp(&y, &((int32_t[4]){10, 20, 30, 40}), sizeof(int32_t[4])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}


	// BUG: НЕ РАБОТАЕТ!
	//	let sa = []Char8 ['L', 'o', 'H', 'i', '!']
	//
	//	if sa[2:4] == "Hi" {
	//		printf("test passed\n")
	//	} else {
	//		printf("test failed\n")
	//	}

	test_arrays();


	// not immediate local array literal test
	int32_t va = 5;
	int32_t vb = 7;
	int32_t varr[4];
	memcpy(&varr, &(int32_t[4]){1, 2, va, vb}, sizeof(int32_t[4]));

	return 0;
}


