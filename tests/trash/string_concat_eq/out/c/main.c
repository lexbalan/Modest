
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define MAIN_HELLO "Hello"
#define MAIN_WORLD "World"
#define MAIN_PARTY_CORN "🎉"
#define MAIN_GREETING MAIN_HELLO " " MAIN_WORLD
//+ " " + party_corn
#define MAIN_TEST "test"

int main(void) {
	printf("%s\n", MAIN_GREETING);
	if (__builtin_strcmp((char *const )&MAIN_TEST, (char *const )&"test") == 0) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}
	return 0;
}

