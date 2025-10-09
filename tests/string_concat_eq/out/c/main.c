// tests/string_concat_eq/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


#define hello  "Hello"
#define world  "World"
#define party_corn  U"🎉"

#define greeting  (hello " " world)//+ " " + party_corn

#define test  "test"

int main() {
	printf("%s\n", (char *)greeting);

	if (true) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}

	return 0;
}


