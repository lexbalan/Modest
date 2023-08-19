
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>


// examples/many_sources/main.cm

#include "./lib.h"

int main(void)
{
    printf("hello from main\n");
    lib_func();
    return 0;
}

