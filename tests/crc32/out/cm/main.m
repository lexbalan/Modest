import "builtin"
import "misc/crc32"
include "ctypes64"
include "stdio"
include "stdlib"

import "misc/crc32" as crc32


const dataBufferLength = 128

type Test = {
	data: [dataBufferLength]Byte
	len: Nat32
	hash: Word32
}


var tests: [3]Test = [
	{
		data = [dataBufferLength]Byte "123456789"
		len = 9
		hash = 0xCBF43926
	}
	{
		data = [dataBufferLength]Byte "The quick brown fox jumps over the lazy dog"
		len = 43
		hash = 0x414FA339
	}
	{
		data = [dataBufferLength]Byte "Test vector from febooti.com"
		len = 28
		hash = 0x0C877F61
	}
]


func runTest (test: *Test) -> Bool {
	let crc: Word32 = crc32.run(*[]Byte &test.data, test.len)
	return crc == test.hash
}


public func main () -> Int {
	printf("test CRC32\n")
	crc32.init()

	var success: Bool = true

	var i = Nat32 0
	while i < lengthof(tests) {
		if not runTest(&tests[i]) {
			printf("test #%d failed\n", i)
			success = false
		} else {
			printf("test #%d passed\n", i)
		}
		i = i + 1
	}

	printf("test ")
	if not success {
		printf("failed\n")
		return exitFailure
	}

	printf("passed\n")
	return exitSuccess
}

