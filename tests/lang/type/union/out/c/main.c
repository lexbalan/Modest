
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>




// Not implemented in LLVM (!)

union union1 {
	uint64_t _nat;
	double _float;
};

__attribute__((used))
static union union1 u1;

int32_t main(void) {
	printf("union test\n");

	bool success = true;

	//	if sizeof(Union1) != max(sizeof(Union._nat), sizeof(Union._float)) {
	//		success = false
	//	}
	//
	//	if alignof(Union1) != max(alignof(Union._nat), alignof(Union._float)) {
	//		success = false
	//	}

	if (sizeof(union union1) != sizeof u1) {
		success = false;
	}

	if (__offsetof(union union1, _nat) != 0) {
		success = false;
	}

	if (__offsetof(union union1, _float) != 0) {
		success = false;
	}

	//printf("sizeof(Union1) = %lu\n", sizeof(Union1))
	//printf("sizeof(u1) = %lu\n", sizeof(u1))

	printf("test ");
	if (!success) {
		printf("failed\n");
		return EXIT_FAILURE;
	}

	printf("passed\n");
	return EXIT_SUCCESS;
}


