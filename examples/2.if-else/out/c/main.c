
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/2.if-else/main.cm


int main(void)
{
    printf((const char *)"if-else example\n");

    int32_t a;
    int32_t b;

    printf((const char *)"enter a: ");
    scanf((const char *)"%d", &a);
    printf((const char *)"enter b: ");
    scanf((const char *)"%d", &b);

    if (a > b) {
        printf((const char *)"a > b\n");
    } else if (a < b) {
        printf((const char *)"a < b\n");
    } else {
        printf((const char *)"a == b\n");
    }

    return 0;
}

