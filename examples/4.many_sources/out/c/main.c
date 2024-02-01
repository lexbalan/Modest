// examples/4.many_sources/main.cm

#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#include <stdio.h>

#include "./lib.h"

int main()
{
    printf("hello from main\n");
    lib_func();
    return 0;
}

