
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/6.text_file/main.cm


#define filename  U"file.txt"


void write_example(void)
{
    printf("run write_example\n");

    FILE *const fp = fopen("file.txt", "w");

    if (fp == NULL) {
        printf("error: cannot create file '%s'", "file.txt");
        return;
    }

    fprintf(fp, "some text.\n");

    fclose(fp);
}


void read_example(void)
{
    printf("run read_example\n");

    FILE *const fp = fopen("file.txt", "r");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", "file.txt");
        return;
    }

    printf("file '%s' contains: ", "file.txt");
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
    printf("text_file example\n");
    write_example();
    read_example();
    return 0;
}

