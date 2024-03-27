// test/builtin_constants/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
    printf("__compilerVersionMajor = %u\n", 0);
    printf("__compilerVersionMinor = %u\n", 7);

    printf("__systemPointerWidth = %u\n", 64);
    printf("__systemCharWidth = %u\n", 8);
    printf("__systemIntWidth = %u\n", 32);
    printf("__systemFloatWidth = %u\n", 64);

    printf("__platformSystem = \"%s\"\n", "Darwin");
    printf("__platformRelease = \"%s\"\n", "21.6.0");

    return 0;
}

