// test/builtin_constants/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




int main()
{
    printf("__compilerVersionMajor = %i\n", 0);
    printf("__compilerVersionMinor = %i\n", 7);

    printf("__systemPointerWidth = %i\n", 64);
    printf("__systemCharWidth = %i\n", 8);
    printf("__systemIntWidth = %i\n", 32);
    printf("__systemFloatWidth = %i\n", 64);

    printf("__platformSystem = %s\n", "Darwin");
    printf("__platformRelease = %s\n", "21.6.0");

    return 0;
}

