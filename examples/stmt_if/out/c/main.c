
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

int main(void) {
	printf("if statement example\n");
	int32_t a = 0;
	int32_t b = 0;
	printf("enter a: ");
	scanf("%d", &a);
	printf("enter b: ");
	scanf("%d", &b);
	if (a > b) {
		printf("a > b\n");
	} else if (a < b) {
		printf("a < b\n");
	} else {
		printf("a == b\n");
	}
	return 0;
}

