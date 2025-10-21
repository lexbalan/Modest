// tests/1.hello_world/src/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define hello  "Hello"
#define world  "World!"

#define hello_world  hello " " world

int main() {
	printf("%s\n", hello_world);
	return 0;
}


