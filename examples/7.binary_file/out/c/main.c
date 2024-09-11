// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



struct main_Chunk {
	char id[100];
	char data[1024];
};
#define filename  "file.bin"
void write_example();
void read_example();
int main();




void write_example()
{
	printf("run write_example\n");

	FILE *const fp = fopen(filename, "wb");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", filename);
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

void read_example()
{
	printf("run read_example\n");

	FILE *const fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return;
	}

	main_Chunk chunk;
	fread(&chunk, sizeof(main_Chunk), 1, fp);

	printf("file \"%s\" contains:\n", filename);
	printf("chunk.id: \"%s\"\n", (char *)&chunk.id);
	printf("chunk.data: \"%s\"\n", (char *)&chunk.data);

	fclose(fp);
}

int main()
{
	printf("binary file example\n");
	write_example();
	read_example();
	return 0;
}

