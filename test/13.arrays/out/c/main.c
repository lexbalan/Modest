
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include "./minmax.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/arrays/main.cm



int32_t globalArray[3] = {1, 2, 3};


int main(void)
{
    int i = 0;
    while (i < 3) {
        const int32_t a = globalArray[i];
        printf("globalArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t localArray[3] = (int32_t [3]){4, 5, 6};

    i = 0;
    while (i < 3) {
        const int32_t a = localArray[i];
        printf("localArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t *p_globalArray;
    p_globalArray = (int32_t *)&globalArray[0];

    i = 0;
    while (i < 3) {
        const int32_t a = p_globalArray[i];
        printf("p_globalArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    printf("------------------------------------\n");

    int32_t *p_localArray;
    p_localArray = (int32_t *)&localArray[0];

    i = 0;
    while (i < 3) {
        const int32_t a = p_localArray[i];
        printf("p_localArray[%d] = %d\n", i, a);
        i = i + 1;
    }

    return 0;
}
