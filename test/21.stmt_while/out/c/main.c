// test/stmt_while/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>


int main()
{
    printf("test stmt_while\n");

    int32_t a = 0;
    const int8_t b = 10;

    while (a < b) {
        printf("a = %d\n", a);
        a = a + 1;
    }

    return 0;
}

