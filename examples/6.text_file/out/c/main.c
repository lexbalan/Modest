
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>



#define FILENAME  ("file.txt")

static void write_example(void) {
	printf(/*4*/"run write_example\n");

	FILE *const fp = fopen(/*4*/FILENAME, /*4*/"w");

	if (fp == NULL) {
		printf(/*4*/"error: cannot create file '%s'", /*4*/(char*)FILENAME);
		return;
	}

	fprintf(fp, /*4*/"some text.\n");

	fclose(fp);
}


static void read_example(void) {
	printf(/*4*/"run read_example\n");

	FILE *const fp = fopen(/*4*/FILENAME, /*4*/"r");

	if (fp == NULL) {
		printf(/*4*/"error: cannot open file '%s'", /*4*/(char*)FILENAME);
		return;
	}

	printf(/*4*/"file '%s' contains: ", /*4*/(char*)FILENAME);
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
	printf(/*4*/"text_file example\n");
	write_example();
	read_example();
	return 0;
}


