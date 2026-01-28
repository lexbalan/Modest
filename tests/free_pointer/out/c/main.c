
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



int32_t main(void) {
	bool a;
	int32_t b;
	int64_t c;

	//
	void *freePointer;

	// free pointer can points to value of any type
	freePointer = (void *)&a;// it's ok (just for demonstration)
	freePointer = (void *)&b;// it's also ok
	freePointer = (void *)&c;// after all it will be points to value c (with type Int64)

	// you can't do dereference operation with Free pointer
	// (because runtime doesn't have any idea about value type it pointee),
	// but you can construct another (non Free) pointer from it
	// and use it as usualy
	*((int64_t *)freePointer) = 123456789123456789L;

	printf("c = 0x%llX\n", c);

	// Let's create new pointer to *Int64 from freePointer
	int64_t *const px = (int64_t *)freePointer;

	// And will use it...
	const int64_t x = *px;

	// for pointer mechanics checking
	printf("x = 0x%llX\n", x);

	return 0;
}


