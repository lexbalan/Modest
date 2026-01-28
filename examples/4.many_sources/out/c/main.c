
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "lib.h"



int main(void) {
	printf(/*4*/"hello from main\n");
	lib_foo();
	return 0;
}


