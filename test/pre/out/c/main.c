// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>


typedef struct Node Node;

typedef uint32_t Data;
struct Node {
	Node *next;
	Data *data;
};
typedef int32_t Int;
#define arrSize  10
typedef Int * Arr;
static Int x;

void printf(char *s, ...);

Int main();

void arrshow(Int *array, Int size);

struct __retval {Int a[arrSize];};
struct __retval getArr();

Int mid(Int a, Int b);

Int div(Int a, Int b);
void printf(char *s, ...);
Int main()
{
	printf("test\n");

	#define a  10
	#define b  20
	const Int s = mid(a, b);
	printf("s = %d\n", s);

	struct __retval arr;
	*(struct __retval *)&arr = getArr();
	arrshow((Int *)(Int *)&arr, 10);

	x = 12;

	return 0;
}

#undef a
#undef b
void arrshow(Int *array, Int size)
{
	printf("arrayShow:\n");
	int32_t i;
	i = 0;
	while (i < 10) {
		printf("array[%d] = %d\n", i, array[i]);
		i = i + 1;
	}
}
struct __retval {Int a[arrSize];};
struct __retval getArr()
{
	return *(struct __retval *)&(struct __retval){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
}
Int mid(Int a, Int b)
{
	const Int sum = a + b;
	return div(sum, 2);
}
Int div(Int a, Int b)
{
	return a / b;
}

//import "libc/stdio"


/*@volatile @atomic*/


// аттрибуты не работают!
//@property("type.c_alias", "int")

