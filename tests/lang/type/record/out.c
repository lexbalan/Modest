
#include "layout_alias.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
struct padded {
	uint8_t tag;
	uint32_t len;
};
typedef struct packed Packed;
struct packed {
	uint8_t tag;
	uint32_t len;
} __attribute__((packed));

static bool testSourceUntouched(void) {
	if (offsetof(struct padded, tag) != 0 || offsetof(struct padded, len) != 4) {
		printf("Padded.tag at %zu, Padded.len at %zu, expected 0 and 4\n", offsetof(struct padded, tag), offsetof(struct padded, len));
		return false;
	}
	if (sizeof(struct padded) != 8 || __alignof(struct padded) != 4) {
		printf("Padded is %zu bytes aligned %zu, expected 8 and 4\n", sizeof(struct padded), __alignof(struct padded));
		return false;
	}
	struct padded p = (struct padded){.tag = 0x7F, .len = 0x11223344};
	if (p.tag != 0x7F || p.len != 0x11223344) {
		printf("p = {%x, %x}, expected {7F, 11223344}\n", (uint32_t)p.tag, p.len);
		return false;
	}
	printf("passed: the record it was taken from is untouched\n");
	return true;
}

static bool testAliasPacked(void) {
	if (offsetof(Packed, tag) != 0 || offsetof(Packed, len) != 1) {
		printf("Packed.tag at %zu, Packed.len at %zu, expected 0 and 1\n", offsetof(Packed, tag), offsetof(Packed, len));
		return false;
	}
	if (sizeof(Packed) != 5 || __alignof(Packed) != 1) {
		printf("Packed is %zu bytes aligned %zu, expected 5 and 1\n", sizeof(Packed), __alignof(Packed));
		return false;
	}
	Packed q = (Packed){.tag = 0x7F, .len = 0x11223344};
	if (q.tag != 0x7F || q.len != 0x11223344) {
		printf("q = {%x, %x}, expected {7F, 11223344}\n", (uint32_t)q.tag, q.len);
		return false;
	}
	printf("passed: the named record is packed\n");
	return true;
}


int main(void) {
	bool result = true;
	result = testSourceUntouched() && result;
	result = testAliasPacked() && result;
	if (!result) {
		printf("failed: layout on a named record\n");
		return EXIT_FAILURE;
	}
	printf("passed: layout on a named record\n");
	return EXIT_SUCCESS;
}

