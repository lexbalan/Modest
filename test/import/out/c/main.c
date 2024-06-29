// test/import/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>
/* forward type declaration */
/* anon recs */

// how to find library
#define library  "libc"

//import library + "/stdio"
//import library + "/libc"
//import library + "/math"

// alternative syntax?




int main()
{
	printf("Smart import test\n");
	return 0;
}

