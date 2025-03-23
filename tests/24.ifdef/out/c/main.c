// tests/34.ifdef/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>





#define __CPU_WORD_WIDTH  64
#define word_name  "'64-bit'"

#define hello_world  ("Hello " word_name " world!")


int main()
{
	printf("%s", (char *)hello_world);
	return 0;
}

