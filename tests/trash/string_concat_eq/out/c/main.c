
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
	if (__builtin_strcmp((char *)&TEST, (char *)&"test") == 0) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}
	return 0;
}

