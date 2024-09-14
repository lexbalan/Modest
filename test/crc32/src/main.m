// test/crc32/src/main.cm

include "libc/ctypes64"
include "libc/ctypes"
include "libc/stdio"

$pragma c_include "./crc32.h"
import "misc/crc32"



let datastring = "123456789"
let expected_hash = 0xCBF43926

var data = []Byte datastring


func main() -> Int {
	printf("CRC32 test\n")

	let crc = crc32.doHash(&data, lengthof(data))

	printf("crc32.doHash(\"%s\") = %08X\n", *Str8 datastring, crc)

	if crc == expected_hash {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

