
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define HELLO "Hello"
#define WORLD "World"
#define PARTY_CORN "🎉"
#define GREETING HELLO " " WORLD
//+ " " + party_corn
#define TEST "test"

int main(void) {
	printf("%s\n", GREETING);
	if (TEST == "test") {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}
	return 0;
}

