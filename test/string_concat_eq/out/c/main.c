
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"

#define main_hello  "Hello"
#define main_world  "World"
#define main_party_corn  U"🎉"

#define main_greeting  (main_hello " " main_world)//+ " " + party_corn


#define main_test  "test"


int main()
{
	printf("%s\n", (char *)main_greeting);

	if (true) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}

	return 0;
}

