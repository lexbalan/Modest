// tests/1.hello_world/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


#define hello  "Hello"
#define world  "World!"

#define hello_world  (hello " " world)

int main() {
	printf("%s\n", (char *)hello_world);
	return 0;
}


