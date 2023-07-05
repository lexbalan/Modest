
#include <stdint.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define filename  "file.bin"

typedef struct {
	uint8_t id[100];
	uint8_t data[1024];
} Chunk;


void write_example() {
	printf("run write_example\n");
	FILE * const fp = fopen(filename, "wb");
	if(fp == NULL) {
		printf("error: cannot create file '%s'", filename);
		return;
	}
	Chunk chunk;
	strcpy((char*)&chunk.id[0], (char*)"id");
	strcpy((char*)&chunk.data[0], (char*)"data");
	fwrite(&chunk, sizeof(Chunk), 1, fp);
	fclose(fp);
}

void read_example() {
	printf("run read_example\n");
	FILE * const fp = fopen(filename, "rb");
	if(fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return;
	}
	Chunk chunk;
	fread(&chunk, sizeof(Chunk), 1, fp);
	printf("file '%s' contains:\n", filename);
	printf("chunk.id: %s\n", &chunk.id[0]);
	printf("chunk.data: %s\n", &chunk.data[0]);
	fclose(fp);
}

int main() {
	printf("text_file example\n");
	write_example();
	read_example();
	return 0;
}

