
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  U"Hello"
#define world  U" World! \x1f389\n"

#define hello_world  hello  world


int main(void)
{
    printf(hello_world);
    return 0;
}

