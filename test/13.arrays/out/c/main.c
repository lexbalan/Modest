// test/arrays/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
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
    memcpy(&localArray, &(int32_t[3]){4, 5, 6}, sizeof localArray);

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


    // assign array to array 1
    int32_t a[3];
    memcpy(&a, &(int32_t[3]){1, 2, 3}, sizeof a);
    int32_t b[3];
    memcpy(&b, &a, sizeof b);
    printf("b[0] = %i\n", b[0]);
    printf("b[1] = %i\n", b[1]);
    printf("b[2] = %i\n", b[2]);

    // assign array to array 2
    /*var c: [3]Int32 = [1, 2, 3]
    var d: [6]Int32 = c to [6]Int32
    printf("d[0] = %i\n", d[0])
    printf("d[1] = %i\n", d[1])
    printf("d[2] = %i\n", d[2])
    printf("d[3] = %i\n", d[3])
    printf("d[4] = %i\n", d[4])
    printf("d[5] = %i\n", d[5])*/

    return 0;
}

