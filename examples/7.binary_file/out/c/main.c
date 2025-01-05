// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define filename  "file.bin"

struct Chunk {
	char id[100];
	char data[1024];
};
typedef struct Chunk Chunk;


static void write_example()
{
	printf("run write_example\n");

	FILE *fp = fopen(filename, "wb");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", filename);
		return;
	}

	Chunk chunk;

	// pointers casting requires -funsafe translator option
	// (see Makefile)
	strcpy(&chunk.id[0], "id");
	strcpy(&chunk.data[0], "data");

	// write chunk to file
	fwrite(&chunk, sizeof(Chunk), 1, fp);

	fclose(fp);
}


static void read_example()
{
	printf("run read_example\n");

	FILE *fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return;
	}

	Chunk chunk;
	fread(&chunk, sizeof(Chunk), 1, fp);

	printf("file \"%s\" contains:\n", filename);
	printf("chunk.id: \"%s\"\n", &chunk.id[0]);
	printf("chunk.data: \"%s\"\n", &chunk.data[0]);

	fclose(fp);
}


int main()
{
	printf("binary file example\n");
	write_example();
	read_example();
	return 0;
}

