// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef struct Node Node;


typedef uint32_t Data;
struct Node {
	Node *next;
	Data *data;
};
typedef int32_t Int;
#define arrSize  10
typedef Int * Arr;

Int main();

struct __retval {Int a[arrSize];};
struct __retval getArr();

Int mid(Int a, Int b);

Int div(Int a, Int b);

//import "libc/stdio"

static Int x;

Int main()
{
	struct __retval arr;
	*(struct __retval *)&arr = getArr();

	#define a  10
	#define b  20
	const Int s = mid(a, b);

	x = 12;

	return 0;
}

#undef a
#undef b

struct __retval {Int a[arrSize];};
struct __retval getArr()
{
	return *(struct __retval *)&(struct __retval){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
}


// аттрибуты не работают!
//@property("type.c_alias", "int")

Int mid(Int a, Int b)
{
	const Int sum = a + b;
	return div(sum, 2);
}

Int div(Int a, Int b)
{
	return a / b;
}

