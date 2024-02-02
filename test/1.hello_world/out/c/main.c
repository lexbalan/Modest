// examples/1.hello_world/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>

//@property("type.c_alias", "Res")
//@property("id.str", "Res")
typedef volatile struct {
    uint32_t v;
} Rec;

static volatile bool x;

static volatile Rec r;

int main()
{
    printf("%s", "Hello World!\n");

    return 0;
}

