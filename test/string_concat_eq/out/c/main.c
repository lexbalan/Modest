// examples/1.hello_world/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

//+ " " + party_corn


int main()
{
    printf("%s\n", "Hello World");

    if (true) {
        printf("test ok.\n");
    } else {
        printf("test failed.\n");
    }

    return 0;
}

