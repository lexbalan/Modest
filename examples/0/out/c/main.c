
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct record {
	char b;
	int32_t a;
	uint16_t c;
};
typedef struct packed Packed;
struct packed {
	char b;
	int32_t a;
	uint16_t c;
} __attribute__((packed));
//type Union = @layout("union") Record
typedef int32_t MyInt;

int main(void) {
	printf("Hello World!\n");
	struct record r = {0};
	Packed p = {0};
	r = (struct record){
		.b = p.b,
		.a = p.a,
		.c = p.c
	};
	printf("sizeof(Record) = %zu\n", sizeof(struct record));
	printf("sizeof(Packed) = %zu\n", sizeof(Packed));
	return 0;
}

