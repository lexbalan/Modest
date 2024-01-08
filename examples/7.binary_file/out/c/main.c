
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/7.binary_file/main.cm


// FIXIT: not worked LLVM result (!)

#define filename  "file.bin"


// chunk of data for read/write operations in file
typedef struct {
    char id[100];
    char data[1024];
} Chunk;


void write_example(void)
{
    printf("run write_example\n");

    FILE *const fp = fopen((char *)filename, "wb");

    if (fp == NULL) {
        printf("error: cannot create file '%s'", filename);
        return;
    }

    Chunk chunk;

    // pointers casting requires -funsafe translator option
    // (see Makefile)
    strcpy((char *)(char *)&chunk.id, (const char *)"id");
    strcpy((char *)(char *)&chunk.data, (const char *)"data");

    // write chunk to file
    fwrite((void *)&chunk, sizeof(Chunk), 1, (FILE *)fp);

    fclose((FILE *)fp);
}


void read_example(void)
{
    printf("run read_example\n");

    FILE *const fp = fopen((char *)filename, "rb");

    if (fp == NULL) {
        printf("error: cannot open file '%s'", filename);
        return;
    }

    Chunk chunk;
    fread((void *)&chunk, sizeof(Chunk), 1, (FILE *)fp);

    printf("file \"%s\" contains:\n", filename);
    printf("chunk.id: \"%s\"\n", (char *)&chunk.id);
    printf("chunk.data: \"%s\"\n", (char *)&chunk.data);

    fclose((FILE *)fp);
}


int main(void)
{
    printf("binary file example\n");
    write_example();
    read_example();
    return 0;
}

