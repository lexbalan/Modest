
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
//include "libc/ctypes64"
//include "libc/stdio"
// не ищет в public include
//public include "libc/stdio"
#define FILENAME "file.txt"


static void write_example(void) {
	printf("run write_example\n");
	FILE *const fp = fopen(FILENAME, "w");
	if (fp == NULL) {
		printf("error: cannot create file '%s'", FILENAME);
		return;
	}
	fprintf(fp, "some text.\n");
	fclose(fp);
}


static void read_example(void) {
	printf("run read_example\n");
	FILE *const fp = fopen(FILENAME, "r");
	if (fp == NULL) {
		printf("error: cannot open file '%s'", FILENAME);
		return;
	}
	printf("file '%s' contains: ", FILENAME);
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
	write_example();
	read_example();
	return 0;
}

