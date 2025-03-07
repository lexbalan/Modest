
@c_include "stdio.h"
@c_include "./crc32.h"
import "misc/crc32" as crc32


const datastring = "123456789"
const expected_hash = 0xCBF43926


var data: [9]Word8 = [9]Word8 datastring


public func main() -> ctypes64.Int {
	stdio.printf("CRC32 test\n")

	let crc = crc32.run(&data, lengthof(data))

	stdio.printf("crc32.doHash(\"%s\") = %08X\n", *Str8 datastring, crc)

	if crc == expected_hash {
		stdio.printf("test passed\n")
	} else {
		stdio.printf("test failed\n")
	}

	return 0
}

