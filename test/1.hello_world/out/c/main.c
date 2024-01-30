// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>










static uint8_t ba[32];

void f(uint8_t *x)
{
}

int main()
{
    printf("%s", "Hello World!\n");

    f((uint8_t *)(uint8_t *)&ba);

    return 0;
}

