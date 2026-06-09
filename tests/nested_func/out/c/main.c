
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

void local(void) {
	int32_t x;
	x = 1;
	(void)x;
	printf("hello from 'local' func!\n");
}

int main(void) {
	typedef int MyInt;
	MyInt x = 0;
	(void)x;
	local();
	return 0;
}

