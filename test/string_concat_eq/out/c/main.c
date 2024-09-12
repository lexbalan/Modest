// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define hello  "Hello"
#define world  "World"
#define party_corn  U"🎉"
#define greeting  (hello " " world)
#define test  "test"
int main();



int main()
{
	printf("%s\n", (char *)greeting);

	if (true) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}

	return 0;
}

