// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define main_hello  "Hello"
#define main_world  "World!"
#define main_hello_world  (main_hello " " main_world)
int main();



int main()
{
	printf("%s\n", (char *)main_hello_world);
	return 0;
}

