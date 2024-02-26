// test/1.hello_world/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
    int32_t x;
    x = 127;
    int32_t y;
    y = x + 1;

    printf("y = %i\n", y);

    if (y == 128) {
        printf("test passed\n");
    } else {
        printf("test failed\n");
    }

    return 0;
}

