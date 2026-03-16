
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define FILENAME ("file.bin")
struct chunk {
	char id[100];
	char data[1024];
};

static void writeExample(void) {
	printf("run writeExample()\n");
	FILE *const fp = fopen(FILENAME, "wb");
	if (fp == NULL) {
		printf("error: cannot create file '%s'", FILENAME);
		return;
	}
	struct chunk chunk = (struct chunk){
		.id = "id",
		.data = "data"
	};
	fwrite((void *)&chunk, sizeof(struct chunk), 1, fp);
	fclose(fp);
}

static void readExample(void) {
	printf("run readExample()\n");
	FILE *const fp = fopen(FILENAME, "rb");
	if (fp == NULL) {
		printf("error: cannot open file '%s'", FILENAME);
		return;
	}
	struct chunk chunk;
	fread((void *)&chunk, sizeof(struct chunk), 1, fp);
	printf("file \"%s\" contains:\n", FILENAME);
	printf("chunk.id: \"%s\"\n", chunk.id);
	printf("chunk.data: \"%s\"\n", chunk.data);
	fclose(fp);
}

int main(void) {
	printf("binary file example\n");
	writeExample();
	readExample();
	return 0;
}

