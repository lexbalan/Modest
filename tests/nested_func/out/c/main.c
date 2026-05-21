
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

void local(void) {
	printf("hello from 'local' func!\n");
}

int main(void) {
	typedef int MyInt;
	local();
	return 0;
}

