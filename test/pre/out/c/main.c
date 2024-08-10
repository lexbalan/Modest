// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "./sub2.h"

typedef struct Node Node;
#include "sub.h"

typedef uint32_t Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int32_t * Arr;
static int32_t x;

int32_t main();

void arrshow(int32_t *array, int32_t size);

int32_t mid(int32_t a, int32_t b);
int32_t main()
{
	printf("test\n");

	printf("%s", (char *)subName);
	printf("%s", (char *)sub2Name);

	#define a  10
	#define b  20
	const int32_t s = mid(a, b);
	printf("s = %d\n", s);

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b
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
int32_t mid(int32_t a, int32_t b)
{
	const int32_t sum = a + b;
	return div(sum, 2);
}

