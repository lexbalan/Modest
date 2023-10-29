
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/0.endianness/main.cm


int main(void)
{
    uint16_t check = 0x0001;
    uint8_t *p_check = (uint8_t *)&check;

    if (*p_check == 1) {
        printf("little");
    } else {
        printf("big");
    }

    printf("-endian\n");

    return 0;
}

