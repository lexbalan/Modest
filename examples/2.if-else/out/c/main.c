
#include <stdint.h>

#include <stdio.h>

int main() {
	printf("if-else example\n");
	int32_t a;
	int32_t b;
	printf("enter a: ");
	scanf("%d", &a);
	printf("enter b: ");
	scanf("%d", &b);
	if(a > b) {
		printf("a > b\n");
	} else if(a < b) {
		printf("a < b\n");
	} else {
		printf("a == b\n");
	}
	return 0;
}

