
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


#define HELLO  "Hello"
#define WORLD  "World"
#define PARTY_CORN  "🎉"

#define GREETING  HELLO " " WORLD  //+ " " + party_corn

#define TEST  "test"

int main(void) {
	printf("%s\n", (char*)GREETING);

	if (true) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}

	return 0;
}


