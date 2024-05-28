// test/1.hello_world/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define hello  "Hello"
#define world  "World!"

#define hello_world  (hello " " world)

//var arrayOfChars = [Char8 "a", 'b', 'c']

int main()
{
	printf("%s\n", (char *)hello_world);
	return 0;
}

