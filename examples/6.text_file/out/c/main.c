// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define main_filename  "file.txt"
void write_example();
void read_example();
int main();



void write_example()
{
	printf("run write_example\n");

	FILE *const fp = fopen(main_filename, "w");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", main_filename);
		return;
	}

	fprintf(fp, "some text.\n");

	fclose(fp);
}

void read_example()
{
	printf("run read_example\n");

	FILE *const fp = fopen(main_filename, "r");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", main_filename);
		return;
	}

	printf("file '%s' contains: ", main_filename);
	while (true) {
		const int ch = fgetc(fp);
		if (ch == EOF) {
			break;
		}
		putchar(ch);
	}

	fclose(fp);
}

int main()
{
	printf("text_file example\n");
	write_example();
	read_example();
	return 0;
}

