
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  U"Hello"
#define world  U"World"
#define party_corn  U"\x1f389"

#define greeting  hello  U" "  world//+ " " + party_corn


#define test  U"test"


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

