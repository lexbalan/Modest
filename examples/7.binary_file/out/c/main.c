// examples/7.binary_file/main.m

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define FILENAME  ("file.bin")

struct Chunk {
	char id[100];
	char data[1024];
};
typedef struct Chunk Chunk;

static void writeExample() {
	printf("run writeExample()\n");

	FILE *const fp = fopen(FILENAME, "wb");
	if (fp == NULL) {
		printf("error: cannot create file '%s'", FILENAME);
		return;
	}

	Chunk chunk = (Chunk){
		.id = "id",
		.data = "data"
	};

	// write chunk to file
	fwrite(&chunk, sizeof(Chunk), 1, fp);

	fclose(fp);
}


static void readExample() {
	printf("run readExample()\n");

	FILE *const fp = fopen(FILENAME, "rb");
	if (fp == NULL) {
		printf("error: cannot open file '%s'", FILENAME);
		return;
	}

	Chunk chunk;
	fread(&chunk, sizeof(Chunk), 1, fp);

	printf("file \"%s\" contains:\n", FILENAME);
	printf("chunk.id: \"%s\"\n", (char *)&chunk.id);
	printf("chunk.data: \"%s\"\n", (char *)&chunk.data);

	fclose(fp);
}


int main() {
	printf("binary file example\n");
	writeExample();
	readExample();
	return 0;
}


