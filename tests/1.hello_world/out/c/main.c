
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#define HARD_CAST_UNSAFE(type, expr) (*(type*)(void*)&(expr))


#define HELLO  "Hello"
#define WORLD  "World!"

#define HELLO_WORLD  HELLO " " WORLD

int main(void) {
	printf("%s\n", (char*)HELLO_WORLD);
	return 0;
}


