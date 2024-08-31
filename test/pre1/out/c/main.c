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
#define add  (&add)
#define default  5// local decls

static
void arrshow(int *array, int size);
static
int div(int a, int b);// defs



static int64_t x;

int main()
{
	printf("test\n");

	printf("sub.name = '%s'\n", (char *)name);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	float f;

	#define __a  10
	#define __b  20
	const int32_t s = mid(__a, __b);
	printf("s = %d\n", s);

	const int d = div(10, 2);

	const int32_t e = ((int32_t (*) (int32_t a, int32_t b))add)((int32_t)d, 1);

	int xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef __a
#undef __b

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

