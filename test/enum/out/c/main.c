// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>




typedef enum {
	modeOff,
	modeStandby,
	modeOn,
} Mode;


void printMode(Mode m)
{
    if (m == modeOff) {
        printf("modeOff\n");
    } else if (m == modeStandby) {
        printf("modeStandby\n");
    } else if (m == modeOn) {
        printf("modeOn\n");
    }
}


int main(void)
{
    printf("enum test");

    Mode m;
    m = modeOff;

    printMode(m);
    return 0;
}

