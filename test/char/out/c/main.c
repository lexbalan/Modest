
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm

#define hello  {} /*GENERIC-STRING*/
#define world  {} /*GENERIC-STRING*/

#define hello_world  hello  world


int main(void)
{
    char ch08;
    uint16_t ch16;
    uint32_t ch32;

    //ch08 := "🐀"[0]  // error
    //ch16 := "🐀"[0]  // error
    ch32 = U'\x1F400';

    ch08 = 's';
    ch16 = u'\x410';
    ch32 = U'\x42F';

    printf("ch08 = 0x%x (%c)\n", ((uint32_t)(uint8_t)ch08), ch08);
    //printf("ch16 = 0x%x (%c)\n", ch16 to Nat32, ch16)
    //printf("ch32 = 0x%x (%c)\n", ch32 to Nat32, ch32)

    printf("%s\n", "Hello World!");

    return 0;
}

