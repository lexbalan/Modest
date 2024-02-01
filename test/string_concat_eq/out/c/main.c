// examples/1.hello_world/main.cm

#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#include <stdio.h>//+ " " + party_corn


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

