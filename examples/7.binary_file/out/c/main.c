// examples/7.binary_file/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


// FIXIT: not worked LLVM result (!)

#define filename  "file.bin"

// chunk of data for read/write operations in file
struct Chunk {
	char id[100];
	char data[1024];
};
typedef struct Chunk Chunk;

static void write_example() {
	printf("run write_example\n");

	FILE *const fp = fopen(filename, "wb");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", filename);
		return;
	}

	Chunk chunk = {
		.id = "id",
		.data = "data"
	};

	// write chunk to file
	fwrite(&chunk, sizeof(Chunk), 1, fp);

	fclose(fp);
}


static void read_example() {
	printf("run read_example\n");

	FILE *const fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return;
	}

	Chunk chunk;
	fread(&chunk, sizeof(Chunk), 1, fp);

	printf("file \"%s\" contains:\n", filename);
	printf("chunk.id: \"%s\"\n", &chunk.id);
	printf("chunk.data: \"%s\"\n", &chunk.data);

	fclose(fp);
}


int main() {
	printf("binary file example\n");
	write_example();
	read_example();
	return 0;
}


