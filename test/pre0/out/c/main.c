// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>
#include "main.h"



typedef struct Node Node;


typedef uint32_t Int;

typedef int Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int * Arr;
#define default  5
#define subName  "Name"// local decls

static
int main();
static
void arrayShow(int *array, int size);
static
int mid(int a, int b);
int div(int a, int b);// defs


static int x;

static
int main()
{
	printf("test\n");

	printf("subName = '%s'\n", (char *)subName);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	#define __a  10
	#define __b  20
	const int s = mid(__a, __b);
	printf("s = %d\n", s);

	int xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef __a
#undef __b

static
void arrayShow(int *array, int size)
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
int mid(int a, int b)
{
	const int sum = a + b;
	return div(sum, 2);
}


