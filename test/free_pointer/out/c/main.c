// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



int32_t main()
{
	bool a;
	int32_t b;
	int64_t c;

	//{'str': ''}
	void *freePointer;

	//{'str': ' free pointer can points to value of any type'}
	freePointer = &a;
	freePointer = &b;
	freePointer = &c;

	//{'str': " you can't do dereference operation with Free pointer"}
	//{'str': " (because runtime doesn't have any idea about value type it pointee),"}
	//{'str': ' but you can construct another (non Free) pointer from it'}
	//{'str': ' and use it as usualy'}
	*(int64_t *)freePointer = 0x123456789ABCDEFLL;

	printf("c = 0x%llX\n", c);

	//{'str': " Let's create new pointer to *Int64 from freePointer"}
	int64_t *px = (int64_t *)freePointer;

	//{'str': ' And will use it...'}
	int64_t x = *px;

	//{'str': ' for pointer mechanics checking'}
	printf("x = 0x%llX\n", x);

	return 0;
}

