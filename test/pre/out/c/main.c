// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef int32_t Int;
Int main();
Int mid(Int a, Int b);
Int div(Int a, Int b);// test/pre/src/main.cm

//import "libc/stdio"


Int main()
{

	#define a  10
	#define b  20
	const Int s = mid(a, b);

	return 0;
}

#undef a
#undef b

// аттрибуты не работают!
//@property("type.c_alias", "int")

Int mid(Int a, Int b)
{
	return div(a + b, 2);
}

Int div(Int a, Int b)
{
	return a / b;
}

