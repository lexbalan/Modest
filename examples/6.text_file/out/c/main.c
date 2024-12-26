// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

//include "libc/ctypes64"
//include "libc/stdio"


#define filename  "file.txt"


static void write_example()
{
	printf("run write_example\n");

	FILE *const fp = fopen(filename, "w");

	if (fp == NULL) {
		printf("error: cannot create file '%s'", filename);
		return;
	}

	fprintf(fp, "some text.\n");

	fclose(fp);
}


static void read_example()
{
	printf("run read_example\n");

	FILE *const fp = fopen(filename, "r");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return;
	}

	printf("file '%s' contains: ", filename);
	while (true) {
		int ch = fgetc(fp);
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

