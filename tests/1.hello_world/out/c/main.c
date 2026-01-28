
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define HELLO  "Hello"
#define WORLD  "World!"

#define HELLO_WORLD  HELLO " " WORLD

int main(void) {
	printf(/*4*/"%s\n", /*4*/(char*)HELLO_WORLD);
	return 0;
}


