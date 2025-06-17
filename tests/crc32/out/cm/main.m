import "misc/crc32"
include "ctypes64"
include "stdio"
// tests/crc32/src/main.m
import "misc/crc32" as crc32


const datastring = "123456789"
const expected_hash = 0xCBF43926


var data = [9]Word8 datastring


public func main () -> Int {
	printf("CRC32 test\n")

	let crc: Word32 = crc32.run(&data, lengthof(data))

	printf("crc32.doHash(\"%s\") = %08X\n", *Str8 datastring, crc)

	if crc == expected_hash {
		printf("test passed\n")
	} else {
		printf("test failed\n")
	}

	return 0
}

