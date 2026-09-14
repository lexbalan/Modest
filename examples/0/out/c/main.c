
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
struct exact {uint8_t tag; uint32_t len;};
typedef struct packed Packed;
struct packed {uint8_t tag; uint32_t len;} __attribute__((packed));

static Packed makePacked(void) {
	printf("called\n");
	return (Packed){.tag = 1, .len = 2};
}

int main(void) {
	printf("Hello World!\n");
	struct exact e = (struct exact){
		.tag = makePacked().tag,
		.len = makePacked().len
	};
	printf("%x %u\n", (uint32_t)e.tag, e.len);
	return 0;
}

