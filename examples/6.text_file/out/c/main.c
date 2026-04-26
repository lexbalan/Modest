
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#define MAIN_FILENAME "file.txt"

static void main_write_example(void) {
	printf("run write_example\n");
	FILE *const fp = fopen(MAIN_FILENAME, "w");
	if (fp == NULL) {
		printf("error: cannot create file '%s'", MAIN_FILENAME);
		return;
	}
	fprintf(fp, "some text.\n");
	fclose(fp);
}

static void main_read_example(void) {
	printf("run read_example\n");
	FILE *const fp = fopen(MAIN_FILENAME, "r");
	if (fp == NULL) {
		printf("error: cannot open file '%s'", MAIN_FILENAME);
		return;
	}
	printf("file '%s' contains: ", MAIN_FILENAME);
	while (true) {
		const int ch = fgetc(fp);
		if (ch == EOF) {
			break;
		}
		putchar(ch);
	}
	fclose(fp);
}

int main(void) {
	printf("text_file example\n");
	main_write_example();
	main_read_example();
	return 0;
}

