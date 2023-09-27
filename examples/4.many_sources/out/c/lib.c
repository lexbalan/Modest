
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/4.many_sources/lib.cm

#include "./lib.h"

void lib_func(void)
{
    printf((const char *)u8"hello from lib_func\n");
}

