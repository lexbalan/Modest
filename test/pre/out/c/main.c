// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef int32_t Int;
typedef Int * Arr;
Int main();
Int mid(Int a, Int b);
Int div(Int a, Int b);
struct getArr_retval {Int a[10];};
struct getArr_retval getArr();

//import "libc/stdio"


Int main()
{
	#define a  10
	#define b  20
	const Int s = mid(a, b);

	struct getArr_retval arr;
	*(struct getArr_retval *)&arr = getArr();

	return 0;
}

#undef a
#undef b

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

struct getArr_retval getArr()
{
	return *(struct getArr_retval *)&(struct getArr_retval){};
}

