// examples/34.ifdef/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>


#define __CPU_WORD_WIDTH  256


int main()
{
    printf("%s", "Hello 'unknown-bit' world!\n");
    return 0;
}

