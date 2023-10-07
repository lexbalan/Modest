
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/stmt_while/main.cm


int main(void)
{
    printf("test stmt_while\n");

    int a = 0;
    const int8_t b = 10;

    while (a < b) {
        printf("a = %d\n", a);
        a = a + 1;
    }

    return 0;
}

