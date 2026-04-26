
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
	FILE *const main_fp = fopen(MAIN_FILENAME, "w");
	if (main_fp == NULL) {
		printf("error: cannot create file '%s'", MAIN_FILENAME);
		return;
	}
	fprintf(main_fp, "some text.\n");
	fclose(main_fp);
}

static void main_read_example(void) {
	printf("run read_example\n");
	FILE *const main_fp = fopen(MAIN_FILENAME, "r");
	if (main_fp == NULL) {
		printf("error: cannot open file '%s'", MAIN_FILENAME);
		return;
	}
	printf("file '%s' contains: ", MAIN_FILENAME);
	while (true) {
		const int main_ch = fgetc(main_fp);
		if (main_ch == EOF) {
			break;
		}
		putchar(main_ch);
	}
	fclose(main_fp);
}

int main(void) {
	printf("text_file example\n");
	main_write_example();
	main_read_example();
	return 0;
}

