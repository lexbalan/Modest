
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <math.h>

//include "libc/ctypes64"
//include "libc/stdio"


#define main_filename  "file.txt"


static void main_write_example()
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


static void main_read_example()
{
	printf("run read_example\n");

	FILE *const fp = fopen(main_filename, "r");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", main_filename);
		return;
	}

	printf("file '%s' contains: ", main_filename);
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
	main_write_example();
	main_read_example();
	return 0;
}

