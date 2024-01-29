// examples/0.endianness/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




int main()
{
    uint16_t check = 0x0001;
    const bool is_le = *(uint8_t *)&check == 1;

    if (is_le) {
        printf("little");
    } else {
        printf("big");
    }

    printf("-endian\n");

    return 0;
}

