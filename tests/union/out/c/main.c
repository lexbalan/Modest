
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>




// Not implemented in LLVM (!)

union union1 {
	int64_t _int;
	double _float;
};

__attribute__((used))
static union union1 u1;

int32_t main(void) {
	printf("union test\n");

	printf("sizeof(Union1) = %lu\n", sizeof(union union1));
	printf("sizeof(u1) = %lu\n", sizeof u1);
	return 0;
}


