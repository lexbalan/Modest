// test/34.ifdef/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




#define __CPU_WORD_WIDTH  64


int main()
{
    printf("%s", "Hello '64-bit' world!");
    return 0;
}

