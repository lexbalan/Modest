
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#define C1 0.1000000000000000001
#define C2 0.2


int main(void) {
	printf("Hello World! %f\n", (double)/*C1 + C2*/0.3000000000000000001);
	return 0;
}

