
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/6.text_file/main.cm


#define filename  "file.txt"


void write_example(void)
{
    printf((const char *)u8"run write_example\n");

    FILE *const fp = fopen(filename, (const char *)u8"w");

    if (fp == NULL) {
        printf((const char *)u8"error: cannot create file '%s'", filename);
        return;
    }

    fprintf(fp, (uint8_t *)u8"some text.\n");

    fclose(fp);
}


void read_example(void)
{
    printf((const char *)u8"run read_example\n");

    FILE *const fp = fopen(filename, (const char *)u8"r");

    if (fp == NULL) {
        printf((const char *)u8"error: cannot open file '%s'", filename);
        return;
    }

    printf((const char *)u8"file '%s' contains: ", filename);
    while (true) {
        const int ch = fgetc(fp);
        if (ch == EOF) {
            break;
        }
        putchar(ch);
    }

    fclose(fp);
}


int main(void)
{
    printf((const char *)u8"text_file example\n");
    write_example();
    read_example();
    return 0;
}

