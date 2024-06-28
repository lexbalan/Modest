// test/import/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <math.h>

// how to find library
#define library  "libc"

//import library + "/stdio"
//import library + "/libc"
//import library + "/math"

// alternative syntax?




int32_t main()
{
	printf("Smart import test\n");
	return 0;
}

