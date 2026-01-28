
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define HELLO  "Hello"
#define WORLD  "World"
#define PARTY_CORN  "🎉"

#define GREETING  HELLO " " WORLD  //+ " " + party_corn

#define TEST  "test"

int main(void) {
	printf(/*4*/"%s\n", /*4*/(char*)GREETING);

	if (true) {
		printf(/*4*/"test ok.\n");
	} else {
		printf(/*4*/"test failed.\n");
	}

	return 0;
}


