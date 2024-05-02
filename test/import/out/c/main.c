// test/import/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <math.h>

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

