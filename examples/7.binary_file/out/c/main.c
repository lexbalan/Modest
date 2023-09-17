
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/binary_file/main.cm


#define filename  "file.bin"


// chunk of data for read/write operations in file
typedef struct {
    uint8_t id[100];
    uint8_t data[1024];
} Chunk;


void write_example(void)
{
    printf("run write_example\n");

    FILE *fp = fopen((const char *)filename, "wb");

    if (fp == NULL) {
        printf("error: cannot create file '%s'", filename);
        return;
    }

    Chunk chunk;

    // pointers casting requires -funsafe translator option
    // (see Makefile)
    strcpy((char *)&chunk.id[0], (char *)"id");
    strcpy((char *)&chunk.data[0], (char *)"data");

    // write chunk to file
    fwrite((void *)&chunk, 0, 1, fp);

    fclose(fp);
}


void read_example(void)
{
    printf("run read_example\n");

    FILE *fp = fopen((const char *)filename, "rb");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return;
    }

    Chunk chunk;
    fread((void *)&chunk, 0, 1, fp);
    printf("file '%s' contains:\n", filename);
    printf("chunk.id: %s\n", &chunk.id[0]);
    printf("chunk.data: %s\n", &chunk.data[0]);

    fclose(fp);
}


int main(void)
{
    printf("text_file example\n");
    write_example();
    read_example();
    return 0;
}

