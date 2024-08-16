// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef struct Node Node;


typedef uint32_t Int;

typedef int Data;

struct Node {
	Node *next;
	Data *data;
};
#define arrSize  10
typedef int * Arr;
#define printf  (&printf)
#define default  5
int main();
void arrshow(int *array, int size);
int mid(int a, int b);
int div(int a, int b);
static int x;
int main()
{
	((void (*) (char *s, ...))printf)("test\n");

	((void (*) (char *s, ...))printf)("sub::name = '%s'\n", (char *)name);
	//printf("sub2Name = '%s'\n", *Str8 sub2Name)

	#define a  10
	#define b  20
	const int s = mid(a, b);
	((void (*) (char *s, ...))printf)("s = %d\n", s);

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
	((void (*) (char *s, ...))printf)("arrayShow:\n");
	int32_t i;
	i = 0;
	while (i < 10) {
		((void (*) (char *s, ...))printf)("array[%d] = %d\n", i, array[i]);
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

