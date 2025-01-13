
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

int32_t main()
{
	int32_t(*pa)[];
	pa = &a;
	p(&a);

	return 0;
}

