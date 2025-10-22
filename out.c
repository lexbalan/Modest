
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

typedef int32_t MyType;

#define CONDITION  1

static int32_t counter = 0;

int32_t main() {
	while (counter < 5) {
		counter = counter + 1;
	}

	if (CONDITION) {
	} else {
	}

	return 0;
}


