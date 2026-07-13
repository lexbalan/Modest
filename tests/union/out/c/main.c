
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
struct rgba_components {
	uint8_t red;
	uint8_t green;
	uint8_t blue;
	uint8_t alpha;
};
union rgba {
	uint32_t code;
	struct rgba_components components;
};

int main(void) {
	union rgba c;
	c.components.red = 255;
	c.components.green = 128;
	c.components.blue = 64;
	c.components.alpha = 32;
	printf("code = %08x\n", c.code);
	return 0;
}

