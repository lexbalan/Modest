
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  {} /*GENERIC-STRING*/
#define world  {} /*GENERIC-STRING*/

#define hello_world  hello  world


int main(void)
{
    printf("Hello World!\n");
    return 0;
}

