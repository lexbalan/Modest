// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




typedef uint32_t Mode;



void printMode(Mode m)
{
    if (m == 0) {
        printf("modeOff\n");
    } else if (m == 1) {
        printf("modeStandby\n");
    } else if (m == 2) {
        printf("modeOn\n");
    }
}


int main(void)
{
    printf("enum test");

    Mode m;
    m = 0;

    printMode(m);
    return 0;
}

