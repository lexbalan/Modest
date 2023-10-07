
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/stmt_while/main.cm


int main(void)
{
    printf("test stmt_while\n");

    int32_t a = (int32_t)0;
    const uint8_t b = 10;

    while (a < b) {
        printf("a = %d\n", a);
        a = a + 1;
    }

    return 0;
}

