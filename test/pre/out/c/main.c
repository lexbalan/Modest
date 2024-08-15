// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./sub2.h"

typedef struct Node Node;
void arrshow();
int32_t main();
void arrshow(int32_t *array, int32_t size);
int32_t mid(int32_t a, int32_t b);
#include "console.h"
#include "sub.h"
#include "sub2.h"

typedef uint32_t Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int32_t * Arr;
#define print  (&printf)
static int32_t x;
void increment()
{
	subCnt = subCnt + 1;
}
int32_t main()
{
	((void (*) (char *s, ...))print)("test\n");

	((void (*) (char *s, ...))print)("sub::subName = '%s'\n", (char *)subName);
	((void (*) (char *s, ...))print)("sub2::sub2Name = '%s'\n", (char *)sub2Name);

	#define a  10
	#define b  20
	const int32_t s = mid(a, b);
	((void (*) (char *s, ...))print)("s = %d\n", s);

	int32_t xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b
void arrayShow(int32_t *array, int32_t size)
{
	((void (*) (char *s, ...))print)("arrayShow:\n");
	int32_t i;
	i = 0;
	while (i < 10) {
		((void (*) (char *s, ...))print)("array[%d] = %d\n", i, array[i]);
		i = i + 1;
	}
}
int32_t mid(int32_t a, int32_t b)
{
	const int32_t sum = a + b;
	return div(sum, 2);
}

