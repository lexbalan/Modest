// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#define LENGTHOF(x) (sizeof(x) / sizeof(x[0]))
//@attribute("c_no_print")
//import "misc/minmax"
//$pragma c_include "./minmax.h"


#define _constantArray  {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
uint8_t constantArray[10] = _constantArray;

static int32_t globalArray[10] = _constantArray;

static char arrayFromString[3] = "abc";
//var arrayOfChars = [Char8 "a", 'b', 'c']


static void f0(char *_x, char *__sret)
{
	char x[20];
	memcpy(x, _x, sizeof(char[20]));
	char local_copy_of_x[20];
	memcpy(&local_copy_of_x, &x, sizeof local_copy_of_x);
	printf("f0(\"%s\")\n", &local_copy_of_x[0]);

	// truncate array
	char mic[6];
	memcpy(&mic, &x, sizeof mic);
	mic[5] = '\x0';

	printf("f0 mic = \"%s\"\n", &mic[0]);

	// extend array
	char res[30];
	memcpy(&res, &x, sizeof res);
	res[6] = 'M';
	res[7] = 'o';
	res[8] = 'd';
	res[9] = 'e';
	res[10] = 's';
	res[11] = 't';
	res[12] = '!';
	res[13] = '\x0';
	memcpy(__sret, &res, sizeof(char[30]));
}


#define _startSequence  {0xAA, 0x55, 0x02}
uint8_t startSequence[3] = _startSequence;
#define _stopSequence  {0x16}
uint8_t stopSequence[1] = _stopSequence;


static void test()
{
	// тестируем работу с локальным generic массивом
	int32_t yy[6];
	memcpy(&yy, &(int32_t[6]){0xAA, 0x55, 0x02, 0x00, 0x00, 0x16}, sizeof yy);
	int32_t i = 0;
	while (i < LENGTHOF(yy)) {
		int32_t y = yy[i];
		printf("yy[%i] = %i\n", i, y);
		i = i + 1;
	}
}


int main()
{
	// generic array [4]Char8 will be implicit casted to [10]Char8

	char em[30];
	f0(em, "Hello World!");
	printf("em = %s\n", &em[0]);

	int32_t i = 0;
	while (i < 10) {
		int32_t a = globalArray[i];
		printf("globalArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t localArray[3];
	memcpy(&localArray, &(int32_t[3]){4, 5, 6}, sizeof localArray);

	i = 0;
	while (i < 3) {
		int32_t a = localArray[i];
		printf("localArray[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t *globalArrayPtr;
	globalArrayPtr = &globalArray[0];

	i = 0;
	while (i < 3) {
		int32_t a = globalArrayPtr[i];
		printf("globalArrayPtr[%i] = %i\n", i, a);
		i = i + 1;
	}

	printf("------------------------------------\n");

	int32_t *localArrayPtr;
	localArrayPtr = &localArray[0];

	i = 0;
	while (i < 3) {
		int32_t a = localArrayPtr[i];
		printf("localArrayPtr[%i] = %i\n", i, a);
		i = i + 1;
	}

	// assign array to array 1
	// (with equal types)
	int32_t a[3];
	memcpy(&a, &(int32_t[3]){1, 2, 3}, sizeof a);
	printf("a[0] = %i\n", a[0]);
	printf("a[1] = %i\n", a[1]);
	printf("a[2] = %i\n", a[2]);

	// create (and initialize) new variable b
	// (with type [3]Int32)
	// this variable are copy of array a
	int32_t b[3];
	memcpy(&b, &a, sizeof b);
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
	memcpy(&c, &(int32_t[3]){10, 20, 30}, sizeof c);
	int32_t d[6];
	memcpy(&d, &c, sizeof d);
	printf("d[0] = %i\n", d[0]);
	printf("d[1] = %i\n", d[1]);
	printf("d[2] = %i\n", d[2]);
	printf("d[3] = %i\n", d[3]);
	printf("d[4] = %i\n", d[4]);
	printf("d[5] = %i\n", d[5]);


	// check equality between two arrays (by pointer)
	int32_t *pa = &a[0];
	int32_t *pb = &b[0];

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
	memcpy(&e, &init_array, sizeof e);
	printf("e[0] = %i\n", e[0]);
	printf("e[1] = %i\n", e[1]);
	printf("e[2] = %i\n", e[2]);

	// check local literal array assignation to global array
	memcpy(&globalArray, &init_array, sizeof globalArray);
	printf("globalArray[%i] = %i\n", 0, globalArray[0]);
	printf("globalArray[%i] = %i\n", 1, globalArray[1]);
	printf("globalArray[%i] = %i\n", 2, globalArray[2]);


	memset(&globalArray, 0, sizeof globalArray);


	// проверка того как локальная константа-массив
	// "замораживает" свои элементы

	int32_t ax = 10;
	int32_t bx = 20;
	int32_t cx = 30;
	int32_t dx = 40;

	int32_t y[4] = {ax, bx, cx, dx};

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
	memcpy(&sa, &"LoHi!", sizeof sa);

	if (memcmp(&sa[2], &"Hi", sizeof(char[2])) == 0) {
		printf("test passed\n");
	} else {
		printf("test failed\n");
	}

	return 0;
}

