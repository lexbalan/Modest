// test/1.hello_world/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define hello  "Hello"
#define world  "World!"

#define hello_world  "Hello World!"


int main()
{
	printf("%s\n", (char *)hello_world);
	return 0;
}

