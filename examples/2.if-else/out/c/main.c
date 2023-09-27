
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/2.if-else/main.cm


int main(void)
{
    printf((const char *)u8"if-else example\n");

    int32_t a;
    int32_t b;

    printf((const char *)u8"enter a: ");
    scanf((const char *)u8"%d", &a);
    printf((const char *)u8"enter b: ");
    scanf((const char *)u8"%d", &b);

    if (a > b) {
        printf((const char *)u8"a > b\n");
    } else if (a < b) {
        printf((const char *)u8"a < b\n");
    } else {
        printf((const char *)u8"a == b\n");
    }

    return 0;
}

