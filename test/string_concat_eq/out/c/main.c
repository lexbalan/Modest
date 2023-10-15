
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  "Hello"
#define world  "World"
#define party_corn  "🎉"

#define greeting  hello  " "  world  " "  party_corn


#define test  "test"


int main(void)
{
    printf("%s\n", greeting);

    if (true) {
        printf("test ok.\n");
    } else {
        printf("test failed.\n");
    }

    return 0;
}

