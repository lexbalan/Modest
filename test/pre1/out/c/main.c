// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./sub.h"
#include "main.h"



typedef struct Node Node;


typedef int32_t Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int32_t * Arr;
#define default  5
static
void arrayShow(int32_t *array, int32_t size);
static
int32_t div(int32_t a, int32_t b);


static int32_t x;

int32_t main()
{
	printf("test\n");

	printf("sub::name = '%s'\n", (char *)name);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	double f;

	#define a  10
	#define b  20
	const int32_t s = mid(a, b);
	printf("s = %d\n", s);

	int32_t xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b

static
void arrshow(int32_t *array, int32_t size)
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
int32_t div(int32_t a, int32_t b)
{
	return a / b;
}

