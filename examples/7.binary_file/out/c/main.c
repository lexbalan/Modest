
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"
#include <string.h>
#include <stdio.h>


// FIXIT: not worked LLVM result (!)

#define main_filename  "file.bin"


// chunk of data for read/write operations in file
struct main_Chunk {
	char id[100];
	char data[1024];
};
typedef struct main_Chunk main_Chunk;


static void main_write_example()
{
	printf("run write_example\n");

	FILE *fp = fopen(main_filename, "wb");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", main_filename);
		return;
	}

	main_Chunk chunk;

	// pointers casting requires -funsafe translator option
	// (see Makefile)
	strcpy((char *)&chunk.id, "id");
	strcpy((char *)&chunk.data, "data");

	// write chunk to file
	fwrite(&chunk, sizeof(main_Chunk), 1, fp);

	fclose(fp);
}


static void main_read_example()
{
	printf("run read_example\n");

	FILE *fp = fopen(main_filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", main_filename);
		return;
	}

	main_Chunk chunk;
	fread(&chunk, sizeof(main_Chunk), 1, fp);

	printf("file \"%s\" contains:\n", main_filename);
	printf("chunk.id: \"%s\"\n", &chunk.id);
	printf("chunk.data: \"%s\"\n", &chunk.data);

	fclose(fp);
}


int main()
{
	printf("binary file example\n");
	main_write_example();
	main_read_example();
	return 0;
}

