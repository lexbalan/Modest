// examples/1.hello_world/src/main.m

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


struct __attribute__((packed)) ProtocolHeader {
	uint16_t start;
	uint16_t len;
};
typedef struct ProtocolHeader ProtocolHeader;

extern int32_t ext;

__attribute__((section("__DATA, .xdata")))
__attribute__((aligned(8)))
static uint32_t x;

static inline int32_t staticInlineFunc(int32_t x) {
	return x + 1;
}

int main() {
	printf("Attributes example\n");
	return 0;
}

