// examples/0.endianness/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "main.h"


std_Int main() {
	std_assert(true, "This assert must not works!\n");
	std_assert(false, "This assert must works!\n");
	return 0;
}

