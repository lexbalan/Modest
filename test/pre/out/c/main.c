// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef int32_t Int;
Int main();
#define arrSize  10
typedef Int * Arr;
struct getArr_retval {Int a[arrSize];};
struct getArr_retval getArr();
Int mid(Int a, Int b);
Int div(Int a, Int b);

//import "libc/stdio"


Int main()
{
	struct getArr_retval arr;
	*(struct getArr_retval *)&arr = getArr();

	#define a  10
	#define b  20
	const Int s = mid(a, b);

	return 0;
}

#undef a
#undef b

struct getArr_retval getArr()
{
	return *(struct getArr_retval *)&(struct getArr_retval){0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
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

