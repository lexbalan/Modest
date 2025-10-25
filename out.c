
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>


//this is
//line comment
/*this is
multiline comment*/

//this is a type definition
typedef int32_t MyType;

//this is a constant definition
#define CONDITION  1

//this is a variable definition
static int32_t counter = 0;

//this is a function definition
int32_t main() {
	while (counter < 5) {
		counter = counter + 1;
	}

	if (CONDITION) {
	} else {
	}

	return 0;
}

static int32_t sum(int32_t a, int32_t b) {
	return a + b;
}


