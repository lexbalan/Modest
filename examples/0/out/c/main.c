
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
struct record {
	char b;
	int32_t a;
	uint16_t c;
};
typedef struct record Packed;
//type Union = @layout("union") Record
typedef int32_t MyInt;

int main(void) {
	printf("Hello World!\n");
	printf("sizeof(Record) = %zu\n", sizeof(struct record));
	printf("sizeof(Packed) = %zu\n", sizeof(Packed));
	return 0;
}

