// test/arrays/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./minmax.h"



static int32_t globalArray[3] = {1, 2, 3};;


struct f0_x {char a[10];};
void f0(struct f0_x x)
{
    //
}


int main()
{
    f0(*(struct f0_x *)&(struct f0_x){'h', 'i', '!', '\0', '\0', '\0', '\0', '\0', '\0', '\0'});

    int32_t i = 0;
    while (i < 3) {
        const int32_t a = globalArray[i];
        printf("globalArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t localArray[3];
    memcpy(&localArray, &(int32_t [3]){4, 5, 6}, sizeof localArray);

    i = 0;
    while (i < 3) {
        const int32_t a = localArray[i];
        printf("localArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t *globalArrayPtr;
    globalArrayPtr = (int32_t *)(int32_t *)&globalArray;

    i = 0;
    while (i < 3) {
        const int32_t a = globalArrayPtr[i];
        printf("globalArrayPtr[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t *localArrayPtr;
    localArrayPtr = (int32_t *)(int32_t *)&localArray;

    i = 0;
    while (i < 3) {
        const int32_t a = localArrayPtr[i];
        printf("localArrayPtr[%d] = %d\n", i, a);
        i = i + 1;
    }

    return 0;
}

