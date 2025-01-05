// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"


typedef int32_t NewInt32;

int main()
{
	printf("test typedef\n");

	NewInt32 newInt32;
	newInt32 = 0;

	//{'str': 'type NewInt16 Int16'}
	//{'str': 'var newInt16: NewInt16'}
	//{'str': 'newInt16 = NewInt16 0'}

	return 0;
}

