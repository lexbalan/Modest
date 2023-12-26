
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/6.text_file/main.cm


#define filename  "file.txt"


void write_example(void)
{
    printf("run write_example\n");

    FILE *const fp = fopen((char *)filename, "w");

    if (fp == NULL) {
        printf("error: cannot create file '%s'", filename);
        return;
    }

    fprintf((FILE *)fp, "some text.\n");

    fclose((FILE *)fp);
}


void read_example(void)
{
    printf("run read_example\n");

    FILE *const fp = fopen((char *)filename, "r");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return;
    }

    printf("file '%s' contains: ", filename);
    while (true) {
        const int ch = fgetc((FILE *)fp);
        if (ch == EOF) {
            break;
        }
        putchar((int)ch);
    }

    fclose((FILE *)fp);
}


int main(void)
{
    printf("text_file example\n");
    write_example();
    read_example();
    return 0;
}

