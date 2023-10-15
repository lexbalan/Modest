
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  "Hello"
#define world  " World! 🎉\n"

#define hello_world  hello  world


int main(void)
{
    printf(hello_world);
    return 0;
}

