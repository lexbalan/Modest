
@c_include "stdio.h"
@c_include "./crc32.h"
import "misc/crc32" as crc32


const datastring = "123456789"
const expected_hash = 0xCBF43926


var data: [<str_value>]Word8 = [<str_value>]Word8 datastring


public func main() -> Int {
	stdio.("CRC32 test\n")

	let crc = crc32.(&data, lengthof(data))

	stdio.("crc32.doHash(\"%s\") = %08X\n", *Str8 datastring, crc)

	if crc == expected_hash {
		stdio.("test passed\n")
	} else {
		stdio.("test failed\n")
	}

	return 0
}

