
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#define MAIN_FILENAME "file.bin"
struct main_chunk {
	char id[100];
	char data[1024];
};

static void main_writeExample(void) {
	printf("run writeExample()\n");
	FILE *const fp = fopen(MAIN_FILENAME, "wb");
	if (fp == NULL) {
		printf("error: cannot create file '%s'", MAIN_FILENAME);
		return;
	}
	struct main_chunk chunk = (struct main_chunk){
		.id = {'i', 'd'},
		.data = {'d', 'a', 't', 'a'}
	};
	fwrite((void *)&chunk, sizeof(struct main_chunk), 1ULL, fp);
	fclose(fp);
}

static void main_readExample(void) {
	printf("run readExample()\n");
	FILE *const fp = fopen(MAIN_FILENAME, "rb");
	if (fp == NULL) {
		printf("error: cannot open file '%s'", MAIN_FILENAME);
		return;
	}
	struct main_chunk chunk;
	fread((void *)&chunk, sizeof(struct main_chunk), 1ULL, fp);
	printf("file \"%s\" contains:\n", MAIN_FILENAME);
	printf("chunk.id: \"%s\"\n", chunk.id);
	printf("chunk.data: \"%s\"\n", chunk.data);
	fclose(fp);
}

int main(void) {
	printf("binary file example\n");
	main_writeExample();
	main_readExample();
	return 0;
}

