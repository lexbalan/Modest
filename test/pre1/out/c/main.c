// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdio.h>
#include "./sub.h"
#include "main.h"



typedef struct Node Node;


typedef int Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int * Arr;
#define default  5// local decls

static
void arrayShow(int *array, int size);
static
int div(int a, int b);// defs



static int x;

int main()
{
	printf("test\n");

	printf("sub::name = '%s'\n", (char *)name);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	float f;

	#define a  10
	#define b  20
	const int32_t s = mid(a, b);
	printf("s = %d\n", s);

	const int d = div(10, 2);

	int xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b

static
void arrshow(int *array, int size)
{
	printf("arrayShow:\n");
	int32_t i;
	i = 0;
	while (i < 10) {
		printf("array[%d] = %d\n", i, array[i]);
		i = i + 1;
	}
}

static
int div(int a, int b)
{
	return a / b;
}

