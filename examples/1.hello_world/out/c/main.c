
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/1.hello_world/main.cm
#include <wchar.h>
typedef char * WCharStr;

//const hello_w16 = "Hello W!\n"

void printw32(uint32_t *wstr)
{
    int i = 0;
    while (true) {
        const uint32_t wc = wstr[i];
        if (wc == 0) {
            break;
        }

/*if wc <= 0xFF {
            printf("%c\n", wc)
        } else if wc <= 0xFFFF {
            printf("%c\n", wc >> 8)
            printf("%c\n", wc and 0xFF)
        } else {
            printf("%c\n", wc >> 24 and 0xFF)
            printf("%c\n", wc >> 16 and 0xFF)
            printf("%c\n", wc >> 8 and 0xFF)
            printf("%c\n", wc and 0xFF)
        }*/

        printf("%d\n", wc);
        i = i + 1;
    }
}

void printw16(uint16_t *wstr)
{
    int i = 0;
    while (true) {
        const uint16_t wc = wstr[i];
        if (wc == 0) {
            break;
        }
        printf("%d\n", wc);
        i = i + 1;
    }
}

int main(void)
{
    wprintf("Hello \x1F400!\n");
    //printf("Hello 🐀!\n")
    //printw16("Hello 🐀!\n")
    //printw32("Hello 🐀!\n")
    //0x1F400
    //printf("%C", '\x1F400')
    return 0;
}

