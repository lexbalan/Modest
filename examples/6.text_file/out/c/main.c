
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

// examples/if-else/main.cm


#define filename  "file.txt"


void write_example(void)
{
    printf("run write_example\n");
    FILE *const fp = fopen(filename, "w");
    if (fp == NULL) {
        printf("error: cannot create file '%s'", filename);
        return;
    }
    fprintf(fp, "some text.\n");
    fclose(fp);
}


void read_example(void)
{
    printf("run read_example\n");
    FILE *const fp = fopen(filename, "r");
    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return;
    }
    printf("file '%s' contains: ", filename);
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

