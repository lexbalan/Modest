
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm


typedef struct {
    uint8_t size_x;
    uint8_t size_y;

    char **data;
} Table;

void show_table(Table *t)
{
}

int main(void)
{
    printf("Hello World!\n");
    return 0;
}

