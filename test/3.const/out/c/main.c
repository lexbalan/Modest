
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/2.func/main.cm

#define genericIntConst  42
#define int32Const  ((int32_t)genericIntConst)

#define genericStringConst  "Hello!"
#define genericString8Const  genericStringConst
//const genericString16Const = genericStringConst to Str16
//const genericString32Const = genericStringConst to Str32


// define function main
int main(void)
{
    printf("test const\n");

    printf("genericIntConst = %d\n", genericIntConst);
    printf("int32Const = %d\n", int32Const);

    printf("genericStringConst = %s\n", genericStringConst);
    printf("genericString8Const = %s\n", genericString8Const);

    return 0;
}

