
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  "<GENERIC-STRING>"
#define world  "<GENERIC-STRING>"
#define party_corn  "<GENERIC-STRING>"

#define greeting  hello  "<GENERIC-STRING>"  world//+ " " + party_corn


#define test  "<GENERIC-STRING>"


int main(void)
{
    printf("%s\n", "Hello World");

    if (true) {
        printf("test ok.\n");
    } else {
        printf("test failed.\n");
    }

    return 0;
}

