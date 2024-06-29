// test/4.typedef/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



typedef int32_t NewInt32;

int main()
{
	printf("test typedef\n");

	NewInt32 newInt32;
	newInt32 = 0;

	//type NewInt16 Int16
	//var newInt16: NewInt16
	//newInt16 = NewInt16 0

	return 0;
}

