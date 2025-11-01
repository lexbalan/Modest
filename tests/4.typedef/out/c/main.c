// tests/4.typedef/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



typedef int32_t NewInt32;

int main(void) {
	printf("test typedef\n");

	NewInt32 newInt32;
	newInt32 = 0;
	(void)newInt32;

	//type NewInt16 Int16
	//var newInt16: NewInt16
	//newInt16 = NewInt16 0

	return 0;
}


