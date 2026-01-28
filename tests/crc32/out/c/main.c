
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./crc32.h"

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define DATASTRING  "123456789"
#define EXPECTED_HASH  0xCBF43926UL

static uint8_t data[9] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

int main(void) {
	printf(/*4*/"CRC32 test\n");

	const uint32_t crc = crc32_run(/*ParamIsPtr2Arr*/&data, LENGTHOF(data));

	printf(/*4*/"crc32.doHash(\"%s\") = %08X\n", /*4*/(char*)DATASTRING, crc);

	if (crc == EXPECTED_HASH) {
		printf(/*4*/"test passed\n");
	} else {
		printf(/*4*/"test failed\n");
	}

	return 0;
}


