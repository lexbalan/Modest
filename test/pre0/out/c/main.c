// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>

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
#define subName  "Name"
int main();
void arrshow(int *array, int size);
int mid(int a, int b);
int div(int a, int b);

#define arrSize  10
static int x;
#define default  5
#define subName  "Name"
int main()
{
	printf("test\n");

	printf("subName = '%s'\n", (char *)subName);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	#define a  10
	#define b  20
	const int s = mid(a, b);
	printf("s = %d\n", s);

	int xx;

	//var arr = getArr()
	//arrayShow(&arr, 10)

	x = 12;

	return 0;
}

#undef a
#undef b
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
int mid(int a, int b)
{
	const int sum = a + b;
	return div(sum, 2);
}
int div(int a, int b)
{
	return a / b;
}

