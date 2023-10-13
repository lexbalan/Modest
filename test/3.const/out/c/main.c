
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// test/3.const/main.cm

#define genericIntConst  42
#define int32Const  genericIntConst

#define genericStringConst  "Hello!"
#define string8Const  genericStringConst
//const genericString16Const = genericStringConst to Str16
//const genericString32Const = genericStringConst to Str32


// define function main
int main(void)
{
    printf("test const\n");

    printf("genericIntConst = %d\n", (int32_t)genericIntConst);
    printf("int32Const = %d\n", int32Const);

    printf("genericStringConst = %s\n", (uint8_t *)genericStringConst);
    printf("string8Const = %s\n", string8Const);

    return 0;
}

