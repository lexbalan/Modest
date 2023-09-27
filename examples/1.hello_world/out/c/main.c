
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

int main(void)
{
    printf((const char *)u8"Hello World!\n");
    return 0;
}

