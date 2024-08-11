// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./sub2.h"

typedef struct Node Node;
#include "console.h"
#include "sub.h"
#include "sub2.h"

typedef uint32_t Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef Int * Arr;
static Int x;

Int main();

void arrayShow(Int *array, Int size);

Int mid(Int a, Int b);
Int main()
{
	printf("test\n");

	printf("%s", (char *)subName);
	printf("%s", (char *)sub2Name);

	#define a  10
	#define b  20
	const Int s = mid(a, b);
	printf("s = %d\n", s);

	Int xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b
void arrayShow(Int *array, Int size)
{
	printf("arrayShow:\n");
	int32_t i;
	i = 0;
	while (i < 10) {
		printf("array[%d] = %d\n", i, array[i]);
		i = i + 1;
	}
}
Int mid(Int a, Int b)
{
	const Int sum = a + b;
	return div(sum, 2);
}

