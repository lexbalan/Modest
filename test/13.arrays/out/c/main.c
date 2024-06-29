// test/arrays/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>
#include "./minmax.h"
/* forward type declaration */
/* anon recs */






#define _constantArray  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
const int8_t constantArray[10] = _constantArray;

static int32_t globalArray[10] = _constantArray;

static char arrayFromString[3] = "abc";


//var arrayOfChars = [Char8 "a", 'b', 'c']


struct f0_x {char a[20];};
struct f0_retval {char a[30];};
struct f0_retval f0(struct f0_x x)
{
	struct f0_x local_copy_of_x;
	*(struct f0_x *)&local_copy_of_x = x;
	printf("f0(\"%s\")\n", (char *)&local_copy_of_x);

	// truncate array
	char mic[6];
	memcpy(&mic, &x, sizeof(char[6]));
	mic[5] = '\x0';

	printf("f0 mic = \"%s\"\n", (char *)&mic);

	// extend array
	char res[30];
	memcpy(&res, &x, sizeof(char[30]));
	res[6] = 'M';
	res[7] = 'o';
	res[8] = 'd';
	res[9] = 'e';
	res[10] = 's';
	res[11] = 't';
	res[12] = '!';
	res[13] = '\x0';
	return *(struct f0_retval *)&res;
}


#define _startSequence  {0xAA, 0x55, 0x02}
const int8_t startSequence[3] = _startSequence;
#define _stopSequence  {0x16}
const int8_t stopSequence[1] = _stopSequence;

void test()
{
	// тестируем работу с локальным generic массивом
	int8_t yy[6];
	memcpy(&yy, &(int8_t[6]){0xAA, 0x55, 0x02, 0x00, 0x00, 0x16}, sizeof(int8_t[6]));
	int32_t i;
	i = 0;
	while (i < (sizeof(yy) / sizeof(yy[0]))) {
		i = i + 1;
	}
}

int main()
{
	// generic array [4]Char8 will be implicit casted to [10]Char8

	struct f0_retval em;
	*(struct f0_retval *)&em = f0(*(struct f0_x *)&"Hello World!");
	printf("em = %s\n", (char *)&em);

	int32_t i;
	i = 0;
	while (i < 10) {
		const int32_t a = globalArray[i];
		printf("globalArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t localArray[3];
	memcpy(&localArray, &(int32_t[3]){4, 5, 6}, sizeof(int32_t[3]));

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
	memcpy(&a, &(int32_t[3]){1, 2, 3}, sizeof(int32_t[3]));
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
	int32_t c[3];
	memcpy(&c, &(int32_t[3]){10, 20, 30}, sizeof(int32_t[3]));
	int32_t d[6];
	memcpy(&d, &c, sizeof(int32_t[6]));
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
	int int100;
	int100 = 100;
	int int200;
	int200 = 200;
	int int300;
	int300 = 300;
	// immutable, non immediate value (array)
	const int init_array[3] = {int100, int200, int300};

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

	int32_t ax;
	ax = 10;
	int32_t bx;
	bx = 20;
	int32_t cx;
	cx = 30;
	const int32_t dx = 40;

	const int32_t y[4] = {ax, bx, cx, dx};

	ax = 111;
	bx = 222;
	cx = 333;

	printf("y[%i] = %i (must be 10)\n", 0, y[0]);
	printf("y[%i] = %i (must be 20)\n", 1, y[1]);
	printf("y[%i] = %i (must be 30)\n", 2, y[2]);
	printf("y[%i] = %i (must be 40)\n", 3, y[3]);

	if (memcmp(&y, &(int32_t[4]){10, 20, 30, 40}, sizeof(int32_t[4])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}


	char sa[5];
	memcpy(&sa, &(char[5]){'L', 'o', 'H', 'i', '!'}, sizeof(char[5]));

	if (memcmp(&sa[2], &"Hi", sizeof(char[4 - 2])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

