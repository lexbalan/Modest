
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/4.many_sources/main.cm

#include "./lib.h"

int main(void)
{
    printf((const char *)u8"hello from main\n");
    lib_func();
    return 0;
}

