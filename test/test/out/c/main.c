
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>


#include <stdlib.h>


#include <string.h>



//@property("type.generic", true)

static int32_t a[2][3] = (int32_t[2][3]){
	1, 2, 3,
	4, 5, 6
};


static void p(int32_t(*pa)[])
{
}


static void foo(int32_t x, int32_t y)
{
	printf("foo(%d, %d)\n", x, y);
}


//$pragma insert "// text insertion"

int32_t main()
{
	int32_t(*pa)[];
	pa = (void *)&a;
	p((void *)&a);

	foo(1, 2);

	return 0;
}

