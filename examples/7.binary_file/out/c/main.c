
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

static void writeExample(void) {
	printf(/*4*/"run writeExample()\n");

	FILE *const fp = fopen(/*4*/FILENAME, /*4*/"wb");
	if (fp == NULL) {
		printf(/*4*/"error: cannot create file '%s'", /*4*/(char*)FILENAME);
		return;
	}

	Chunk chunk = (Chunk){
		.id = {'i', 'd'},
		.data = {'d', 'a', 't', 'a'}
	};

	// write chunk to file
	fwrite((void *)&chunk, sizeof(Chunk), 1, fp);

	fclose(fp);
}


static void readExample(void) {
	printf(/*4*/"run readExample()\n");

	FILE *const fp = fopen(/*4*/FILENAME, /*4*/"rb");
	if (fp == NULL) {
		printf(/*4*/"error: cannot open file '%s'", /*4*/(char*)FILENAME);
		return;
	}

	Chunk chunk;
	fread((void *)&chunk, sizeof(Chunk), 1, fp);

	printf(/*4*/"file \"%s\" contains:\n", /*4*/(char*)FILENAME);
	printf(/*4*/"chunk.id: \"%s\"\n", /*4*/(char*)&chunk.id);
	printf(/*4*/"chunk.data: \"%s\"\n", /*4*/(char*)&chunk.data);

	fclose(fp);
}


int main(void) {
	printf(/*4*/"binary file example\n");
	writeExample();
	readExample();
	return 0;
}


